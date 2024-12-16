#include <WiFi.h>
#include <WiFiClientSecure.h>
#include <MQTT.h>
#include <ArduinoJson.h>
#include "secrets.h" // Include secrets.h for AWS credentials
#include "RFID_reader.h" // Include your updated RFID reader logic

WiFiClientSecure net; // Secure client for MQTT
MQTTClient client;

const char* topic_uid = "esp32/sub";
const char* topic_status = "arduino/reader/uid";

// LED pins
#define ledPinGreen 32
#define ledPinRed 33

void connectWiFi() {
  Serial.print("Connecting to Wi-Fi...");
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);

  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }

  Serial.println("\nWiFi connected");
  Serial.print("IP Address: ");
  Serial.println(WiFi.localIP());
}

void connectMQTT() {
  while (!client.connect(THINGNAME)) {
    Serial.print(".");
    delay(1000);
  }
  Serial.println("\nConnected to AWS IoT");
}

void sendToAWS(const String& cardUID) {
  StaticJsonDocument<200> doc;
  doc["cardUID"] = cardUID;

  char jsonBuffer[512];
  serializeJson(doc, jsonBuffer);

  if (client.publish(topic_uid, jsonBuffer)) {
    Serial.println("Successfully sent to AWS IoT:");
    Serial.println(jsonBuffer);
  } else {
    Serial.println("Failed to send to AWS IoT.");
  }
}

void messageHandler(String &topic, String &payload) {
  Serial.println("Incoming message: " + topic + " - " + payload);

  StaticJsonDocument<200> doc;
  deserializeJson(doc, payload);

  int status = doc["status"];
  Serial.println(status);

  if (status == 1) {
    digitalWrite(ledPinGreen, HIGH);
    delay(5000);
    digitalWrite(ledPinGreen, LOW);
    Serial.println("El marcatge s'ha rebut correctament (status 1)");
  } else if (status == 0) {
    digitalWrite(ledPinRed, HIGH);
    delay(5000);
    digitalWrite(ledPinRed, LOW);
    Serial.println("El marcatge ha fallat (status 0)");
  }
}

void setup() {
  Serial.begin(9600);
  pinMode(ledPinGreen, OUTPUT);
  pinMode(ledPinRed, OUTPUT);

  connectWiFi();

  net.setCACert(AWS_CERT_CA);
  net.setCertificate(AWS_CERT_CRT);
  net.setPrivateKey(AWS_CERT_PRIVATE);

  client.begin(AWS_IOT_ENDPOINT, 8883, net);
  client.onMessage(messageHandler);

  connectMQTT();

  client.subscribe(topic_status);
  Serial.println("Subscribed to topic: " + String(topic_status));

  RFID_setup();
  
}

void loop() {
  client.loop();

  if (readAndFormatNUID()) {
    String cardUID = getNUID();
    Serial.print("Detected card UID: ");
    Serial.println(cardUID);

    sendToAWS(cardUID);
  }

  delay(1000);
}

