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
const char* shadow_update_topic = "$aws/things/Projecte_ESP32/shadow/name/ESP32_grup03/update";
const char* shadow_get_topic = "$aws/things/Projecte_ESP32/shadow/name/ESP32_grup03/get";

// LED pins
#define ledPinGreen 32
#define ledPinRed 33

// Tracks the device's current status
bool deviceOnline = true;

// Wi-Fi Connection
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

// MQTT Connection
void connectMQTT() {
  while (!client.connect(THINGNAME)) {
    Serial.print(".");
    delay(1000);
  }
  Serial.println("\nConnected to AWS IoT");

  // Subscribe to general topics
  client.subscribe(topic_status);
  Serial.println("Subscribed to topic: " + String(topic_status));
}

// Function to send shadow updates for monitoring device status
void sendShadowUpdate(bool online) {
  StaticJsonDocument<200> doc;
  doc["state"]["reported"]["status"] = online ? "online" : "offline";

  char jsonBuffer[512];
  serializeJson(doc, jsonBuffer);

  if (client.publish(shadow_update_topic, jsonBuffer)) {
    Serial.println("Shadow update sent:");
    Serial.println(jsonBuffer);
  } else {
    Serial.println("Failed to send shadow update.");
  }
}

// Function to handle incoming messages
void messageHandler(String &topic, String &payload) {
  Serial.println("Incoming message: " + topic + " - " + payload);

  StaticJsonDocument<200> doc;
  deserializeJson(doc, payload);

  int status = doc["status"]; // Example: {"status": 0}
  if (status == 1) {
    Serial.println("El marcatge s'ha rebut correctament (status 1)");
    digitalWrite(ledPinGreen, HIGH);
    delay(5000);
    digitalWrite(ledPinGreen, LOW);
    
  } else if (status == 0) {
    Serial.println("El marcatge ha fallat (status 0)");
    digitalWrite(ledPinRed, HIGH);
    delay(5000);
    digitalWrite(ledPinRed, LOW);
  }
}

// Function to periodically send monitoring messages to IoT Shadow
void monitorESP32Status() {
  static unsigned long lastMonitorTime = 0; // Timestamp for the last shadow update
  unsigned long currentMillis = millis();

  if (currentMillis - lastMonitorTime > 60000) { // Send status every 60 seconds
    sendShadowUpdate(deviceOnline); // Report the device as online
    lastMonitorTime = currentMillis;
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

  // Initial shadow update to mark the device as online
  sendShadowUpdate(true);

  RFID_setup();
}

void loop() {
  client.loop(); // Keep the MQTT connection alive

  monitorESP32Status(); // Periodically send ESP32 status updates

  if (readAndFormatNUID()) {
    String cardUID = getNUID();
    Serial.print("Detected card UID: ");
    Serial.println(cardUID);

    // Send the detected card UID to the topic
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

  delay(1000);
}

