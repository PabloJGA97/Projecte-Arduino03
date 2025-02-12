from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from typing import List
from client import db_client
app = FastAPI()

# Pydantic model to validate input data
class AsistenciaRequest(BaseModel):
    id_alumno: int
    fecha: str  # Se espera que la fecha esté en formato 'YYYY-MM-DD'

# Pydantic model to represent the response data
class AsistenciaResponse(BaseModel):
    data: str  # Fecha
    hora_inici: str
    hora_final: str
    estat: str
    nom_aula: str
    assignatura: str


@app.post("/assistencia/alumno", response_model=List[AsistenciaResponse])
async def get_assistance(request: AsistenciaRequest):
    # Conectar a la base de datos
    db = db_client()
    
    # Realizar la consulta SQL
    cursor = db.cursor(dictionary=True)
    query = '''
        SELECT a.data, a.hora_inici, a.hora_final, a.estat, au.nom_aula, asg.nom AS assignatura
        FROM Assistencia a
        JOIN Aula au ON a.aula_id = au.aula_id
        JOIN Assignatures asg ON a.assignatura_id = asg.assignatura_id
        WHERE a.usuari_id = ? AND a.data = ?
    '''
    
    cursor.execute(query, (request.id_alumno, request.fecha))
    rows = cursor.fetchall()

    # Si no hay resultados, lanzar un error
    if not rows:
        raise HTTPException(status_code=404, detail="No se encontraron resultados para este alumno en esa fecha.")
    
    # Transformar los resultados en formato JSON
    asistencia_list = []
    for row in rows:
        asistencia_list.append(AsistenciaResponse(
            data=row['data'],
            hora_inici=row['hora_inici'],
            hora_final=row['hora_final'],
            estat=row['estat'],
            nom_aula=row['nom_aula'],
            assignatura=row['assignatura']
        ))

    # Cerrar la conexión a la base de datos
    db.close()
    
    return asistencia_list
