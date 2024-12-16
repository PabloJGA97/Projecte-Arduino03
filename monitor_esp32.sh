#!/bin/bash

THING_NAME="Projecte_ESP32"

# recivim el json mitjancant una comanda amb aws cli i el parsejem per imprimir el resultat
# per pantalla
response=$(aws iot-data get-thing-shadow --thing-name "$THING_NAME")

if [ $? -eq 0 ]; then
    echo "Thing Shadow for $THING_NAME:"
    echo "$response" | jq '.'
else
    echo "Failed to retrieve Thing Shadow for $THING_NAME."
fi
