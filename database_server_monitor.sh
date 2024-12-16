#!/bin/bash
# Verificar l'estat de AWS IoT

aws_iot_endpoint="a302ucw63g5l7h-ats.iot.us-east-1.amazonaws.com"
status=$(aws iot describe-endpoint --endpoint-type iot:Data-ATS --output text --query 'endpointAddress')
timestamp=$(date '+%Y-%m-%d %H:%M:%S')

if [ "$status" == "$aws_iot_endpoint" ]; then
    echo "$timestamp AWS IoT funciona correctament"
else
    echo "$timestamp Alerta: AWS IoT no está disponible o ha canviat d'endpoint"
fi


# Verificar connectivitat i estat del servei de la base de dades PostgresSQL

pg_host="192.168.33.8"
pg_user="professor"  
pg_password="pditicbcn"  
pg_database="project_bbdd"  

export PGPASSWORD="$pg_password"

bbdd_service="postgresql.service"

# Revisa l'estatus del servei postgresql
systemctl is-active --quiet "$bbdd_service";

if [ $? -eq 0 ]; then
    echo "$timestamp PostgreSQL servei està funcionant correctament."
else
    echo "$timestamp ALERTA: PostgreSQL servei NO està funcionant!"
fi


# Revisa que podem connectar-nos a la base de dades
psql -h "$pg_host" -U "$pg_user" -d "$pg_database" -c "\dt;" > /dev/null 2>&1

if [ $? -eq 0 ]; then
    echo "$timestamp la base de dades '$pg_database' està funcionant i té connectivitat."
else
    echo "$timestamp ALERTA: no es pot connectar a la base de dades '$pg_database'."
fi


