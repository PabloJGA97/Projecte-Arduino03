#!/bin/bash
# Verificar l'estat de AWS IoT
aws_iot_endpoint="a302ucw63g5l7h-ats.iot.us-east-1.amazonaws.com"
status=$(aws iot describe-endpoint --endpoint-type iot:Data-ATS --output text --query 'endpointAddress')

if [ "$status" == "$aws_iot_endpoint" ]; then
    echo "AWS IoT está funcionando correctamente."
else
    echo "Alerta: AWS IoT no está disponible o el endpoint no coincide."
fi


# # Verificar el estado de la base de datos MySQL
# mysql_host="localhost"
# mysql_user="root"
# mysql_password="1234"
# mysqladmin ping -h "$mysql_host" -u "$mysql_user" -p"$mysql_password" > /dev/null 2>&1
# if [ $? -eq 0 ]; then
#     echo "La base de datos MySQL está funcionando correctamente."
# else
#     echo "Alerta: La base de datos MySQL no está disponible."
# fi
# # Verificar el estado del servidor Apache
# apache_service="apache2"
# systemctl is-active --quiet $apache_service
# if [ $? -eq 0 ]; then
#     echo "El servidor Apache está funcionando correctamente."
# else
#     echo "Alerta: El servidor Apache no está disponible."
# fi
