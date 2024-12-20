-- CREACIÓ ROLS

create user admin with password 'pass_admin!' with superuser;

create user alumne with password 'pass_alumne';

create user professor with password 'pass_prof';


-- ALUMNES 

ALTER DEFAULT PRIVILEGES IN SCHEMA public REVOKE ALL ON TABLES FROM alumne;
GRANT SELECT ON TABLE usuari TO alumne;
GRANT SELECT ON TABLE assistencia TO alumne;

-- GPROFESSOR
REVOKE ALL ON ALL TABLES IN SCHEMA public FROM professor;
GRANT SELECT ON TABLE usuari TO professor;
GRANT SELECT ON TABLE grup TO professor;

-- Grant MODIFY (UPDATE, DELETE) on assistencia
GRANT SELECT, UPDATE, DELETE ON TABLE assistencia TO professor;

-- Grant SELECT, MODIFY (UPDATE, DELETE), and INSERT on horari
GRANT SELECT, UPDATE, DELETE, INSERT ON TABLE horari TO professor;

-- donem tots els permisos de la taula a admin
ALTER DATABASE project_bbdd OWNER TO admin;
