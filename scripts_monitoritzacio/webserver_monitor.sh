#!/bin/bash

# variables dels dos serveis
APACHE_SERVICE="apache2"
BIND9_SERVICE="bind9"
timestamp=$(date '+%Y-%m-%d %H:%M:%S')

# Condicional per fer els prints del'estatus del servidor web
systemctl is-active --quiet "$APACHE_SERVICE"
if [[ $? -eq 0 ]]; then
    echo "$timestamp Apache funciona correctament"
else
    echo "$timestamp ALERTA: Apache no està funcionant"
fi

# Condiciona per fer els prints de l'estatus del DNS 
systemctl is-active --quiet "$BIND9_SERVICE"
if [[ $? -eq 0 ]]; then
    echo "$timestamp el servei DNS funciona correctament"
else
    echo "$timestamp ALERTA: el servei DNS no està disponible"
fi


