#!/bin/bash

# Thing and Shadow details
THING_NAME="Projecte_ESP32"
SHADOW_NAME="ESP32_grup03"
ENDPOINT="https://a302ucw63g5l7h-ats.iot.us-east-1.amazonaws.com"
timestamp=$(date '+%Y-%m-%d %H:%M:%S')

# Output file for the shadow state
OUTPUT_FILE="state.json"

# Get the shadow
aws iot-data get-thing-shadow --thing-name "$THING_NAME" --shadow-name "$SHADOW_NAME" "$OUTPUT_FILE" --endpoint-url "$ENDPOINT" 2>/dev/null

# Parse the status key from the JSON file
STATUS=$(jq -r '.state.reported.status' "$OUTPUT_FILE" 2>/dev/null) 

# Check and print the state
if [ "$STATUS" == "online" ]; then
    echo "$timestamp El dispositiu ESP32 funciona i està en línia."
elif [ "$STATUS" == "offline" ]; then
    echo "$timestamp ALERTA: El dispositiu ESP32 no està en línia"
else
    echo "$timestamp ALERTA: El dispositiu ESP32 no es troba en líniea o ha parat la seva activitat"
fi

# delete the created json after reading it's value 
rm state.json 2>/dev/null

