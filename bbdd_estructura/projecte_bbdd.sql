-- Drop tables if they exist to reset the database
DROP TABLE IF EXISTS assistencia CASCADE;
DROP TABLE IF EXISTS horari CASCADE;
DROP TABLE IF EXISTS matricula CASCADE;
DROP TABLE IF EXISTS usuari CASCADE;
DROP TABLE IF EXISTS assignatura CASCADE;
DROP TABLE IF EXISTS curs CASCADE;
DROP TABLE IF EXISTS grup CASCADE;
DROP TABLE IF EXISTS aula CASCADE;
DROP TABLE IF EXISTS lloc CASCADE;
DROP TABLE IF EXISTS edifici CASCADE;
DROP TABLE IF EXISTS departament CASCADE;

-- Create the tables

CREATE TABLE departament (
    dep_id INTEGER PRIMARY KEY,
    nom VARCHAR
);

CREATE TABLE grup (
    grup_id INTEGER PRIMARY KEY,
    nom VARCHAR
);

CREATE TABLE edifici (
    edifici_id INTEGER PRIMARY KEY,
    nom VARCHAR,
    direccio VARCHAR,
    municipi VARCHAR
);

CREATE TABLE aula (
    aula_id INTEGER PRIMARY KEY,
    edifici_id INTEGER,
    nom_aula VARCHAR,
    pis INTEGER,
    departament VARCHAR,
    FOREIGN KEY (edifici_id) REFERENCES edifici(edifici_id) ON DELETE CASCADE
);

CREATE TABLE usuari (
    nuid VARCHAR PRIMARY KEY,
    grup_id INTEGER,
    dep_id INTEGER,
    cognom TEXT,
    email VARCHAR,
    pass VARCHAR,
    rol VARCHAR,
    FOREIGN KEY (grup_id) REFERENCES grup(grup_id) ON DELETE CASCADE,
    FOREIGN KEY (dep_id) REFERENCES departament(dep_id) ON DELETE CASCADE
);

CREATE TABLE curs (
    curs_id INTEGER PRIMARY KEY,
    nom_curs VARCHAR,
    numero INTEGER
);

CREATE TABLE assignatura (
    assignatura_id INTEGER PRIMARY KEY,
    aula_id INTEGER,
    nom VARCHAR,
    hora_inici TIMESTAMP,
    hora_final TIMESTAMP,
    FOREIGN KEY (aula_id) REFERENCES aula(aula_id) ON DELETE CASCADE
);

CREATE TABLE horari (
    horari_id INTEGER PRIMARY KEY,
    data_inici TIMESTAMP,
    data_final TIMESTAMP,
    assignatura_id INTEGER,
    aula_id INTEGER,
    edifici_id INTEGER,
    professor_id VARCHAR,
    curs_id INTEGER,
    hora_inici TIMESTAMP,
    hora_final TIMESTAMP,
    FOREIGN KEY (assignatura_id) REFERENCES assignatura(assignatura_id) ON DELETE CASCADE,
    FOREIGN KEY (aula_id) REFERENCES aula(aula_id) ON DELETE CASCADE,
    FOREIGN KEY (edifici_id) REFERENCES edifici(edifici_id) ON DELETE CASCADE,
    FOREIGN KEY (professor_id) REFERENCES usuari(nuid) ON DELETE CASCADE,
    FOREIGN KEY (curs_id) REFERENCES curs(curs_id) ON DELETE CASCADE
);

CREATE TABLE lloc (
    lloc_id INTEGER PRIMARY KEY,
    aula_id INTEGER,
    edifici_id INTEGER,
    horari_id INTEGER,
    FOREIGN KEY (aula_id) REFERENCES aula(aula_id) ON DELETE CASCADE,
    FOREIGN KEY (edifici_id) REFERENCES edifici(edifici_id) ON DELETE CASCADE,
    FOREIGN KEY (horari_id) REFERENCES horari(horari_id) ON DELETE CASCADE
);

CREATE TABLE assistencia (
    assistencia_id INTEGER PRIMARY KEY,
    alumne_id VARCHAR,
    professor_id VARCHAR,
    assignatura_id INTEGER,
    data TIMESTAMP,
    estat VARCHAR,
    FOREIGN KEY (alumne_id) REFERENCES usuari(nuid) ON DELETE CASCADE,
    FOREIGN KEY (professor_id) REFERENCES usuari(nuid) ON DELETE CASCADE,
    FOREIGN KEY (assignatura_id) REFERENCES assignatura(assignatura_id) ON DELETE CASCADE
);

CREATE TABLE matricula (
    matricula_id INTEGER PRIMARY KEY,
    alumne_id VARCHAR,
    assignatura_id INTEGER,
    grup_id INTEGER,
    assistencia_id INTEGER,
    FOREIGN KEY (alumne_id) REFERENCES usuari(nuid) ON DELETE CASCADE,
    FOREIGN KEY (assignatura_id) REFERENCES assignatura(assignatura_id) ON DELETE CASCADE,
    FOREIGN KEY (grup_id) REFERENCES grup(grup_id) ON DELETE CASCADE,
    FOREIGN KEY (assistencia_id) REFERENCES assistencia(assistencia_id) ON DELETE CASCADE
);

