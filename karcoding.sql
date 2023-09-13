CREATE SCHEMA karcoding;

CREATE TABLE karcoding.Grupo_Empresarial (
    Grupo_Empresarial_ID serial primary key,
    Nombre_Grupo VARCHAR(255) NOT NULL
);

CREATE TABLE karcoding.Marca (
    Marca_ID serial primary key,
    Nombre_Marca VARCHAR(255) NOT NULL,
    Grupo_Empresarial_ID INT
);

CREATE TABLE karcoding.Aseguradora (
    Aseguradora_ID serial primary key,
    Nombre_Aseguradora VARCHAR(255) NOT NULL
);

CREATE TABLE karcoding.Coche (
    Coche_ID serial primary key,
    Modelo VARCHAR(255) NOT NULL,
    Color VARCHAR(255) NOT NULL,
    Matricula VARCHAR(20) UNIQUE NOT NULL,
    Kilometraje NUMERIC NOT NULL,
    Fecha_Compra DATE NOT NULL,
    Aseguradora_ID INT,
    Numero_Poliza VARCHAR(255) NOT NULL,
    Marca_ID INT
);

CREATE TABLE karcoding.Revision (
    Revision_ID serial primary key,
    Coche_ID INT,
    Kilometraje_Revision NUMERIC NOT NULL,
    Fecha_Revision DATE NOT NULL,
    Moneda VARCHAR(255) NOT NULL
);

SELECT
    C.Modelo AS "Nombre Modelo",
    M.Nombre_Marca AS "Marca",
    G.Nombre_Grupo AS "Grupo de Coches",
    C.Fecha_Compra AS "Fecha de Compra",
    C.Matricula,
    C.Color AS "Nombre del Color del Coche",
    C.Kilometraje AS "Total de Kilómetros",
    C.Aseguradora_ID AS "Empresa Aseguradora",
    C.Numero_Poliza AS "Número de Póliza"
FROM
    karcoding.Coche AS C
    JOIN karcoding.Marca AS M ON C.Marca_ID = M.Marca_ID
    JOIN karcoding.Grupo_Empresarial AS G ON M.Grupo_Empresarial_ID = G.Grupo_Empresarial_ID
    JOIN (
        SELECT Coche_ID, MAX(Fecha_Revision) AS Fecha_Revision
        FROM karcoding.Revision
        GROUP BY Coche_ID
    ) AS R ON C.Coche_ID = R.Coche_ID
WHERE
    C.Fecha_Compra IS NOT NULL;


ALTER TABLE karcoding.Coche
ADD CONSTRAINT FK_Coche_Aseguradora FOREIGN KEY (Aseguradora_ID) REFERENCES karcoding.Aseguradora(Aseguradora_ID);

ALTER TABLE karcoding.Coche
ADD CONSTRAINT FK_Coche_Marca FOREIGN KEY (Marca_ID) REFERENCES karcoding.Marca(Marca_ID);

ALTER TABLE karcoding.Revision
ADD CONSTRAINT FK_Revision_Coche FOREIGN KEY (Coche_ID) REFERENCES karcoding.Coche(Coche_ID);

ALTER TABLE karcoding.Marca
ADD CONSTRAINT FK_Marca_Grupo_Empresarial FOREIGN KEY (Grupo_Empresarial_ID) REFERENCES karcoding.Grupo_Empresarial(Grupo_Empresarial_ID);

insert into karcoding.grupo_empresarial (nombre_grupo) select grupo from karcoding.cochescoding group by grupo order by grupo;
insert into karcoding.aseguradora (nombre_aseguradora) select aseguradora from karcoding.cochescoding group by aseguradora;
--insert into karcoding.marca (nombre_marca, grupo_empresarial_id) select marca, 1 from karcoding.cochescoding group by marca

select c.marca, m.grupo_empresarial_id  from karcoding.cochescoding c inner join karcoding.marca m on c.marca = m.nombre_marca order by marca;
--insert into karcoding.coche (matricula) select matricula from karcoding.cochescoding 


select * from karcoding.cochescoding c
