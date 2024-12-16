#include <SPI.h>
#include <MFRC522.h>

#define SS_PIN 5
#define RST_PIN 0

MFRC522 rfid(SS_PIN, RST_PIN); // Instance of the class
String currentNUID = "";       // String to hold the current NUID

void RFID_setup() {
  SPI.begin();          // Init SPI bus
  rfid.PCD_Init();      // Init MFRC522
  Serial.println("RFID Reader initialized.");
}

bool readAndFormatNUID() {
  // Look for new cards
  if (!rfid.PICC_IsNewCardPresent() || !rfid.PICC_ReadCardSerial()) {
    return false;
  }

  // Debug: Print raw UID bytes
  Serial.print("Raw UID bytes: ");
  for (byte i = 0; i < rfid.uid.size; i++) {
    Serial.print(rfid.uid.uidByte[i], HEX);
    Serial.print(" ");
  }
  Serial.println();

  // Format NUID as a HEX string with leading zeros
  currentNUID = "";
  for (byte i = 0; i < rfid.uid.size; i++) {
    if (i > 0) {
      currentNUID.concat(" "); // Add a space between bytes
    }
    // Ensure two-character formatting with leading zeros
    if (rfid.uid.uidByte[i] < 0x10) {
      currentNUID.concat("0"); // Add a leading zero if needed
    }
    currentNUID.concat(String(rfid.uid.uidByte[i], HEX));
  }
  currentNUID.toUpperCase();

  // Debug: Print formatted NUID
  Serial.print("Formatted NUID: ");
  Serial.println(currentNUID);

  // Halt the PICC and stop encryption
  rfid.PICC_HaltA();
  rfid.PCD_StopCrypto1();

  return true;
}

String getNUID() {
  return currentNUID;
}

