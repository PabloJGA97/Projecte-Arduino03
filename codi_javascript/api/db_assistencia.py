from client import db_client

def consultar_asistencia(id_alumno: int, fecha: str):
    db = db_client()
    if not db:
        return None

    try:
        cursor = db.cursor(dictionary=True)
        query = """
            SELECT a.assistencia_id, a.data, a.hora_inici, a.hora_final, a.estat, au.nom_aula, asig.nom AS assignatura
            FROM Assistencia a
            JOIN Aula au ON a.aula_id = au.aula_id
            JOIN Assignatures asig ON a.assignatura_id = asig.assignatura_id
            WHERE a.usuari_id = %s AND a.data = %s;
        """
        cursor.execute(query, (id_alumno, fecha))
        result = cursor.fetchall()
        return result if result else None
    except Exception as e:
        print(f"Error al consultar asistencia: {e}")
        return None
    finally:
        db.close()
