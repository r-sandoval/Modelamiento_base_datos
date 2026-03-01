/* ========= 01. IMPIEZA DE TABLAS Y SECUENCIAS =================*/
DROP TABLE DETALLE_SERVICIO CASCADE CONSTRAINTS;
DROP TABLE MANTENCION CASCADE CONSTRAINTS;
DROP TABLE AUTOMOVIL CASCADE CONSTRAINTS;
DROP TABLE SUCURSAL CASCADE CONSTRAINTS;
DROP TABLE MECANICO CASCADE CONSTRAINTS;
DROP TABLE MODELO CASCADE CONSTRAINTS;
DROP TABLE ESTANDAR CASCADE CONSTRAINTS;
DROP TABLE PREMIUM CASCADE CONSTRAINTS;
DROP TABLE CIUDAD CASCADE CONSTRAINTS;
DROP TABLE CLIENTE CASCADE CONSTRAINTS;
DROP TABLE MARCA CASCADE CONSTRAINTS;
DROP TABLE TIPO_AUTOMOVIL CASCADE CONSTRAINTS;
DROP TABLE SERVICIO CASCADE CONSTRAINTS;
DROP TABLE PAIS CASCADE CONSTRAINTS;
DROP SEQUENCE SEQ_SERVICIO;
DROP SEQUENCE SEQ_CIUDAD;
PURGE RECYCLEBIN;
COMMIT;


/* ============= IMPLEMENTACIÓN DEL MODELO ================== */
CREATE TABLE PAIS (
    id_pais     NUMBER(3) GENERATED ALWAYS AS IDENTITY (START WITH 9 INCREMENT BY 3), 
    nom_pais    VARCHAR2(30) NOT NULL,
    CONSTRAINT PAIS_PK PRIMARY KEY (id_pais)
);

CREATE TABLE CIUDAD (
    id_ciudad   NUMBER(3),
    nom_ciudad  VARCHAR2(30) NOT NULL,
    cod_pais    NUMBER(3) NOT NULL,
    CONSTRAINT CIUDAD_PK PRIMARY KEY (id_ciudad),
    CONSTRAINT CIUDAD_FK_PAIS FOREIGN KEY (cod_pais) REFERENCES PAIS(id_pais)
);

CREATE TABLE SUCURSAL (
    id_sucursal  CHAR(3),
    nom_sucursal VARCHAR2(20) NOT NULL,
    calle        VARCHAR2(20) NOT NULL,
    num_calle    NUMBER(4) NOT NULL,
    cod_ciudad   NUMBER(3) NOT NULL,
    CONSTRAINT SUCURSAL_PK PRIMARY KEY (id_sucursal),
    CONSTRAINT SUCURSAL_FK FOREIGN KEY (cod_ciudad) REFERENCES CIUDAD (id_ciudad) 
);

CREATE TABLE MARCA (
    id_marca    NUMBER(2),
    descripción VARCHAR2(20) NOT NULL,
    CONSTRAINT MARCA_PK PRIMARY KEY (id_marca)
);

CREATE TABLE MODELO (
    id_modelo   NUMBER(5),
    marca_id    NUMBER(2),
    descripción VARCHAR2(20) NOT NULL,
    CONSTRAINT MODELO_PK PRIMARY KEY (id_modelo, marca_id),
    CONSTRAINT MODELO_FK_MARCA FOREIGN KEY (marca_id) REFERENCES MARCA (id_marca)  
);

CREATE TABLE TIPO_AUTOMOVIL (
    id_tipo     CHAR(3),
    descripcion VARCHAR2(20),
    CONSTRAINT TIPO_AUTO_PK PRIMARY KEY (id_tipo)
);

CREATE TABLE CLIENTE (
    rut       NUMBER(8),
    dv        CHAR(1) NOT NULL,
    pnombre   VARCHAR2(20) NOT NULL,
    snombre   VARCHAR2(20),
    apaterno  VARCHAR2(20) NOT NULL,
    amaterno  VARCHAR2(20) NOT NULL,
    telefono  VARCHAR2(12),
    email     VARCHAR2(40),
    tipo_cli  CHAR(1),
    CONSTRAINT CLIENTE_PK PRIMARY KEY (rut)
);

CREATE TABLE ESTANDAR (
    cl_rut            NUMBER(8),
    puntaje_fidelidad NUMBER(10) NOT NULL,
    CONSTRAINT ESTANDAR_PK PRIMARY KEY (cl_rut),
    CONSTRAINT ESTANDAR_FK_CLIENTE FOREIGN KEY (cl_rut) REFERENCES CLIENTE (rut)
);

CREATE TABLE PREMIUM (
    cl_rut          NUMBER(8),
    pesos_clientes  NUMBER(10) NOT NULL,
    monto_credito   NUMBER(10),
    CONSTRAINT PREMIUM_PK PRIMARY KEY (cl_rut),
    CONSTRAINT PREMIUM_FK_CLIENTE FOREIGN KEY (cl_rut) REFERENCES CLIENTE (rut)
);

CREATE TABLE MECANICO (
    cod_mecanico    NUMBER(5) GENERATED ALWAYS AS IDENTITY (START WITH 460 INCREMENT BY 7),
    pnombre         VARCHAR2(20) NOT NULL,
    snombre         VARCHAR2(20) NOT NULL,
    apaterno        VARCHAR2(20) NOT NULL,
    amaterno        VARCHAR2(20) NOT NULL,
    bono_jefatura   NUMBER(10),
    sueldo          NUMBER(10) NOT NULL,
    monto_impuestos NUMBER(10) NOT NULL,
    cod_supervisor  NUMBER(5),
    CONSTRAINT MECANICO_PK PRIMARY KEY (cod_mecanico),
    CONSTRAINT MECANICO_FK_MECANICO FOREIGN KEY (cod_supervisor) REFERENCES MECANICO (cod_mecanico)
);

CREATE TABLE SERVICIO (
    id_servicio NUMBER(3),
    descripcion VARCHAR2(100) NOT NULL,
    costo       NUMBER(7) NOT NULL,
    CONSTRAINT SERVICIO_PK PRIMARY KEY (id_servicio)
);

CREATE TABLE AUTOMOVIL (
    patente       CHAR(8),
    annio         NUMBER(4) NOT NULL,
    cant_puertas  NUMBER(1) NOT NULL,
    km            NUMBER(6) NOT NULL,
    color         VARCHAR2(30) NOT NULL,
    cod_tipo_auto CHAR(3) NOT NULL,
    cod_modelo    NUMBER(5) NOT NULL,
    cod_marca     NUMBER(2) NOT NULL,
    cl_rut        NUMBER(8) NOT NULL,
    CONSTRAINT AUTOMOVIL_PK PRIMARY KEY (patente),
    CONSTRAINT AUTOMOVIL_FK_CLIENTE FOREIGN KEY (cl_rut) REFERENCES CLIENTE (rut),
    CONSTRAINT AUTOMOVIL_FK_MODELO FOREIGN KEY (cod_modelo, cod_marca) REFERENCES MODELO (id_modelo, marca_id),
    CONSTRAINT AUTOMOVIL_FK_TIPO FOREIGN KEY (cod_tipo_auto) REFERENCES TIPO_AUTOMOVIL (id_tipo)
);

CREATE TABLE MANTENCION (
    num_mantencion NUMBER(4),
    cod_sucursal   CHAR(3) NOT NULL,
    fecha_ingreso  DATE NOT NULL,
    fecha_salida   DATE,
    patente_auto   CHAR(8),
    cod_mecanico   NUMBER(5) NOT NULL,  
    costo_total    NUMBER(7) NOT NULL,
    estado         VARCHAR2(15),
    CONSTRAINT MANTENCION_PK PRIMARY KEY (num_mantencion),
    CONSTRAINT MANT_FK_AUTOMOVIL FOREIGN KEY (patente_auto) REFERENCES AUTOMOVIL (patente),
    CONSTRAINT MANT_FK_MECANICO FOREIGN KEY (cod_mecanico) REFERENCES MECANICO (cod_mecanico),
    CONSTRAINT MANT_SUCURSAL FOREIGN KEY (cod_sucursal) REFERENCES SUCURSAL (id_sucursal)
);

CREATE TABLE DETALLE_SERVICIO (
    mantencion_num NUMBER(4) NOT NULL,
    cod_servicio   NUMBER(3) NOT NULL,
    desc_serv      NUMBER(4,3) NOT NULL,
    cantidad       NUMBER(3) NOT NULL,
    CONSTRAINT DETALLE_SERVICIO_PK PRIMARY KEY (mantencion_num, cod_servicio),
    CONSTRAINT DET_SERV_FK_MANTENCION FOREIGN KEY (mantencion_num) REFERENCES MANTENCION (num_mantencion),
    CONSTRAINT DET_SERV_FK_SERVICIO FOREIGN KEY (cod_servicio) REFERENCES SERVICIO (id_servicio)
);

CREATE SEQUENCE SEQ_SERVICIO START WITH 400 INCREMENT BY 2;
CREATE SEQUENCE SEQ_CIUDAD START WITH 165 INCREMENT BY 5;
COMMIT;
 
 
 
 
/* =========== CASO 2:MODIFICACIÓN DEL MODELO ==========*/
ALTER TABLE MANTENCION DROP COLUMN costo_total;
COMMIT;

ALTER TABLE DETALLE_SERVICIO 
DROP CONSTRAINT DET_SERV_FK_MANTENCION;
COMMIT;

ALTER TABLE MANTENCION 
DROP CONSTRAINT MANTENCION_PK;
COMMIT;

ALTER TABLE MANTENCION 
ADD CONSTRAINT MANTENCION_PK PRIMARY KEY (num_mantencion, cod_sucursal);
COMMIT;

ALTER TABLE DETALLE_SERVICIO ADD (id_sucursal CHAR(3) NOT NULL);
COMMIT;

ALTER TABLE DETALLE_SERVICIO 
ADD CONSTRAINT DET_SERV_FK_MANTENCION 
FOREIGN KEY (mantencion_num, id_sucursal) 
REFERENCES MANTENCION (num_mantencion, cod_sucursal);
COMMIT;

ALTER TABLE CLIENTE ADD CONSTRAINT EMAIL_U UNIQUE (email);
ALTER TABLE CLIENTE ADD CONSTRAINT DV_CHECK CHECK (dv IN('0','1','2','3','4','5','6','7','8','9','K','k'));
COMMIT;

ALTER TABLE MECANICO ADD CONSTRAINT CHECK_MECANICO_SUELDO CHECK (sueldo >= 510000);
ALTER TABLE MANTENCION ADD CONSTRAINT CHECKK_MANTENCION_ESTADO CHECK (estado IN('Reserva', 'Ingresado', 'Entregado', 'Anulado'));
COMMIT;


/* ============= CASO 3:POBLAMIENTO DEL MODELO =================== */
INSERT INTO PAIS (NOM_PAIS) VALUES ('Chile');
INSERT INTO PAIS (NOM_PAIS) VALUES ('Peru');
INSERT INTO PAIS (NOM_PAIS) VALUES ('Colombia');
COMMIT;

INSERT ALL 
    INTO MARCA (id_marca, descripción) VALUES (10, 'Toyota')
    INTO MARCA (id_marca, descripción) VALUES (20, 'Hyundai')
    INTO MARCA (id_marca, descripción) VALUES (30, 'Chevrolet')
    INTO MARCA (id_marca, descripción) VALUES (40, 'Ford')
    INTO MARCA (id_marca, descripción) VALUES (50, 'Suzuki')
SELECT * FROM DUAL;
COMMIT;

INSERT ALL 
    INTO TIPO_AUTOMOVIL (id_tipo, descripcion) VALUES ('SED', 'Sedan')
    INTO TIPO_AUTOMOVIL (id_tipo, descripcion) VALUES ('SUV', 'SUV')
    INTO TIPO_AUTOMOVIL (id_tipo, descripcion) VALUES ('PCK', 'Pick-up')
    INTO TIPO_AUTOMOVIL (id_tipo, descripcion) VALUES ('HCH', 'Hatchback')
    INTO TIPO_AUTOMOVIL (id_tipo, descripcion) VALUES ('FUR', 'Furgon')
SELECT * FROM DUAL;
COMMIT;

INSERT ALL 
    INTO CLIENTE (rut, dv, pnombre, snombre, apaterno, amaterno, telefono, email, tipo_cli) 
    VALUES (11222333, 'K', 'Carlos', 'Alberto', 'Gonzalez', 'Lopez', '912345678', 'c.gonzalez@email.com', 'P')
    INTO CLIENTE (rut, dv, pnombre, snombre, apaterno, amaterno, telefono, email, tipo_cli) 
    VALUES (12333444, '5', 'Ana', 'Maria', 'Rodriguez', 'Perez', '923456789', 'a.rodriguez@email.com', 'E')
    INTO CLIENTE (rut, dv, pnombre, snombre, apaterno, amaterno, telefono, email, tipo_cli) 
    VALUES (13444555, '0', 'Juan', 'Pablo', 'Soto', 'Soto', '934567890', 'j.soto@email.com', 'E')
    INTO CLIENTE (rut, dv, pnombre, snombre, apaterno, amaterno, telefono, email, tipo_cli) 
    VALUES (14555666, '7', 'Lucia', 'Fernanda', 'Morales', 'Rivas', '945678901', 'l.morales@email.com', 'P')
    INTO CLIENTE (rut, dv, pnombre, snombre, apaterno, amaterno, telefono, email, tipo_cli) 
    VALUES (15666777, '1', 'Pedro', 'Andres', 'Castro', 'Vargas', '956789012', 'p.castro@email.com', 'E')
SELECT * FROM DUAL;
COMMIT;

-- SERVICIO
INSERT INTO SERVICIO (ID_SERVICIO, DESCRIPCION, COSTO) 
VALUES (SEQ_SERVICIO.NEXTVAL, 'Cambio Luces', 45000);
INSERT INTO SERVICIO (ID_SERVICIO, DESCRIPCION, COSTO) 
VALUES (SEQ_SERVICIO.NEXTVAL, 'Desabolladura', 67000);
INSERT INTO SERVICIO (ID_SERVICIO, DESCRIPCION, COSTO) 
VALUES (SEQ_SERVICIO.NEXTVAL, 'Revisión Frenos', 30000);
INSERT INTO SERVICIO (ID_SERVICIO, DESCRIPCION, COSTO) 
VALUES (SEQ_SERVICIO.NEXTVAL, 'Cambio Puerta Trasera', 5000);
COMMIT;

-- CIUDAD
INSERT INTO CIUDAD (ID_CIUDAD, NOM_CIUDAD, COD_PAIS) VALUES (SEQ_CIUDAD.NEXTVAL, 'Santiago', 9);
COMMIT;
INSERT INTO CIUDAD (ID_CIUDAD, NOM_CIUDAD, COD_PAIS) VALUES (SEQ_CIUDAD.NEXTVAL, 'Lima', 12);
COMMIT;
INSERT INTO CIUDAD (ID_CIUDAD, NOM_CIUDAD, COD_PAIS) VALUES (SEQ_CIUDAD.NEXTVAL, 'Bogotá', 15);
COMMIT;

INSERT ALL 
    INTO MODELO (id_modelo, marca_id, descripción) VALUES (101, 10, 'Corolla')
    INTO MODELO (id_modelo, marca_id, descripción) VALUES (102, 20, 'Accent')
    INTO MODELO (id_modelo, marca_id, descripción) VALUES (103, 30, 'Sail')
    INTO MODELO (id_modelo, marca_id, descripción) VALUES (104, 40, 'Ranger')
    INTO MODELO (id_modelo, marca_id, descripción) VALUES (105, 50, 'Swift')
SELECT * FROM DUAL;
COMMIT;

-- SUCURSAL
INSERT ALL 
    INTO SUCURSAL (ID_SUCURSAL, NOM_SUCURSAL, CALLE, NUM_CALLE, COD_CIUDAD) 
    VALUES ('S01', 'Providencia', 'Av. A. Varas', 234, 165)
    INTO SUCURSAL (ID_SUCURSAL, NOM_SUCURSAL, CALLE, NUM_CALLE, COD_CIUDAD) 
    VALUES ('S02', 'Las 4 esquinas', 'Av. Latina', 669, 170)
    INTO SUCURSAL (ID_SUCURSAL, NOM_SUCURSAL, CALLE, NUM_CALLE, COD_CIUDAD) 
    VALUES ('S03', 'El Cafetero', 'Av. El Faro', 900, 175)
SELECT * FROM DUAL;
COMMIT;

-- MECÁNICO
INSERT INTO MECANICO
(PNOMBRE, SNOMBRE, APATERNO, AMATERNO, BONO_JEFATURA, SUELDO, MONTO_IMPUESTOS, COD_SUPERVISOR)
VALUES ('Jorge', 'Pablo', 'Soto', 'Sierpe', 5400000, 2759000, 223580, NULL);
INSERT INTO MECANICO
(PNOMBRE, SNOMBRE, APATERNO, AMATERNO, BONO_JEFATURA, SUELDO, MONTO_IMPUESTOS, COD_SUPERVISOR)
VALUES ('Pedro', 'Jose', 'Manriquez', 'Corral', NULL, 759000, 23980, NULL);
INSERT INTO MECANICO
(PNOMBRE, SNOMBRE, APATERNO, AMATERNO, BONO_JEFATURA, SUELDO, MONTO_IMPUESTOS, COD_SUPERVISOR)
VALUES ('Sandra', 'Josefa', 'Letelier', 'S.', 0, 659000, 22358, 460);
INSERT INTO MECANICO
(PNOMBRE, SNOMBRE, APATERNO, AMATERNO, BONO_JEFATURA, SUELDO, MONTO_IMPUESTOS, COD_SUPERVISOR)
VALUES ('Felipe', 'M.', 'Vidal', 'A.', NULL, 759000, 23580, 460);
INSERT INTO MECANICO
(PNOMBRE, SNOMBRE, APATERNO, AMATERNO, BONO_JEFATURA, SUELDO, MONTO_IMPUESTOS, COD_SUPERVISOR)
VALUES ('Jose', 'Miguel', 'Troncoso', 'B.', NULL, 659000, 44580, 474);
INSERT INTO MECANICO
(PNOMBRE, SNOMBRE, APATERNO, AMATERNO, BONO_JEFATURA, SUELDO, MONTO_IMPUESTOS, COD_SUPERVISOR)
VALUES ('Juan', 'Pablo', 'Sanchez', 'R.', NULL, 859000, 23380, 474);
INSERT INTO MECANICO
(PNOMBRE, SNOMBRE, APATERNO, AMATERNO, BONO_JEFATURA, SUELDO, MONTO_IMPUESTOS, COD_SUPERVISOR)
VALUES ('Carlos', 'Felipe', 'Soto', 'J.', 0, 597000, 23580, 474);
INSERT INTO MECANICO
(PNOMBRE, SNOMBRE, APATERNO, AMATERNO, BONO_JEFATURA, SUELDO, MONTO_IMPUESTOS, COD_SUPERVISOR)
VALUES ('Alberto', 'P.', 'Cerda', 'Ramirez', NULL, 559000, 22380, 460);
INSERT INTO MECANICO
(PNOMBRE, SNOMBRE, APATERNO, AMATERNO, BONO_JEFATURA, SUELDO, MONTO_IMPUESTOS, COD_SUPERVISOR)
VALUES ('Alejandra', 'Gabriela', 'Infanti', 'R.', NULL, 659000, 22380, 460);
INSERT INTO MECANICO
(PNOMBRE, SNOMBRE, APATERNO, AMATERNO, BONO_JEFATURA, SUELDO, MONTO_IMPUESTOS, COD_SUPERVISOR)
VALUES ('Roberto', 'Patricio', 'Gutierrez', 'Sosa', NULL, 859000, 22380, 460);

COMMIT;

INSERT ALL 
    INTO ESTANDAR (cl_rut, puntaje_fidelidad) VALUES (12333444, 150)
    INTO ESTANDAR (cl_rut, puntaje_fidelidad) VALUES (13444555, 300)
    INTO ESTANDAR (cl_rut, puntaje_fidelidad) VALUES (15666777, 50)
SELECT * FROM DUAL;
COMMIT;

INSERT ALL 
    INTO PREMIUM (cl_rut, pesos_clientes, monto_credito) VALUES (11222333, 50000, 1000000)
    INTO PREMIUM (cl_rut, pesos_clientes, monto_credito) VALUES (14555666, 75000, 1500000)
SELECT * FROM DUAL;
COMMIT;

INSERT ALL 
    INTO AUTOMOVIL (patente, annio, cant_puertas, km, color, cod_tipo_auto, cod_modelo, cod_marca, cl_rut) 
    VALUES ('BBDD-10', 2022, 4, 15000, 'Blanco', 'SED', 101, 10, 11222333)
    INTO AUTOMOVIL (patente, annio, cant_puertas, km, color, cod_tipo_auto, cod_modelo, cod_marca, cl_rut) 
    VALUES ('SQL-202', 2021, 3, 35000, 'Gris Plata', 'SUV', 102, 20, 12333444)
    INTO AUTOMOVIL (patente, annio, cant_puertas, km, color, cod_tipo_auto, cod_modelo, cod_marca, cl_rut) 
    VALUES ('ORCL-50', 2023, 2, 5000, 'Rojo', 'PCK', 104, 40, 13444555)
    INTO AUTOMOVIL (patente, annio, cant_puertas, km, color, cod_tipo_auto, cod_modelo, cod_marca, cl_rut) 
    VALUES ('JAVA-88', 2020, 3, 60000, 'Azul Marino', 'HCH', 105, 50, 14555666)
    INTO AUTOMOVIL (patente, annio, cant_puertas, km, color, cod_tipo_auto, cod_modelo, cod_marca, cl_rut) 
    VALUES ('PLSQL-0', 2019, 4, 85000, 'Negro', 'SED', 103, 30, 15666777)
SELECT * FROM DUAL;
COMMIT;

-- MANTENCIÓN
INSERT ALL 
    INTO MANTENCION (NUM_MANTENCION, COD_SUCURSAL, FECHA_INGRESO, FECHA_SALIDA, PATENTE_AUTO, COD_MECANICO, ESTADO) 
    VALUES (101, 'S01', TO_DATE('12-04-2023', 'DD-MM-YYYY'), NULL, NULL, 481, 'Reserva')
    INTO MANTENCION (NUM_MANTENCION, COD_SUCURSAL, FECHA_INGRESO, FECHA_SALIDA, PATENTE_AUTO, COD_MECANICO, ESTADO) 
    VALUES (102, 'S02', TO_DATE('21-02-2023', 'DD-MM-YYYY'), TO_DATE('21-02-2023', 'DD-MM-YYYY'), NULL, 502, 'Entregado')
    INTO MANTENCION (NUM_MANTENCION, COD_SUCURSAL, FECHA_INGRESO, FECHA_SALIDA, PATENTE_AUTO, COD_MECANICO, ESTADO) 
    VALUES (103, 'S02', TO_DATE('09-10-2023', 'DD-MM-YYYY'), NULL, NULL, 502, 'Anulado')
    INTO MANTENCION (NUM_MANTENCION, COD_SUCURSAL, FECHA_INGRESO, FECHA_SALIDA, PATENTE_AUTO, COD_MECANICO, ESTADO) 
    VALUES (104, 'S03', TO_DATE('11-08-2023', 'DD-MM-YYYY'), TO_DATE('18-08-2023', 'DD-MM-YYYY'), NULL, 509, 'Entregado')
    INTO MANTENCION (NUM_MANTENCION, COD_SUCURSAL, FECHA_INGRESO, FECHA_SALIDA, PATENTE_AUTO, COD_MECANICO, ESTADO) 
    VALUES (105, 'S03', TO_DATE('03-12-2023', 'DD-MM-YYYY'), NULL, NULL, 509, 'Ingresado')
SELECT * FROM DUAL;
COMMIT;

INSERT ALL 
    INTO DETALLE_SERVICIO (mantencion_num, id_sucursal, cod_servicio, desc_serv, cantidad) 
    VALUES (101, 'S01', 400, 0.000, 2)
    INTO DETALLE_SERVICIO (mantencion_num, id_sucursal, cod_servicio, desc_serv, cantidad) 
    VALUES (102, 'S02', 402, 0.050, 1)
    INTO DETALLE_SERVICIO (mantencion_num, id_sucursal, cod_servicio, desc_serv, cantidad) 
    VALUES (103, 'S02', 404, 0.000, 1)
    INTO DETALLE_SERVICIO (mantencion_num, id_sucursal, cod_servicio, desc_serv, cantidad) 
    VALUES (104, 'S03', 406, 0.100, 1)
    INTO DETALLE_SERVICIO (mantencion_num, id_sucursal, cod_servicio, desc_serv, cantidad) 
    VALUES (105, 'S03', 400, 0.000, 1)
SELECT * FROM DUAL;
COMMIT;




/* ================= CASO 4: RECUPERACIÓN DE DATOS ========================== */

-- INFORME 1:
SELECT 
    cod_mecanico AS "ID MECANICO",
    pnombre || ' ' || apaterno AS "NOMBRE MECANICO",
    sueldo AS "SALARIO",
    monto_impuestos AS "IMPUESTO ACTUAL",
        (monto_impuestos * 0.8) AS "IMPUESTO REBAJADO",
        (sueldo - (monto_impuestos * 0.8)) AS "SUELDO CON REBAJA IMPUESTOS"
FROM 
    MECANICO
WHERE 
    bono_jefatura IS NULL 
    AND monto_impuestos < 40000
ORDER BY 
    "IMPUESTO ACTUAL" DESC, 
    apaterno ASC;

-- INFORME 2:
SELECT 
    cod_mecanico AS "IDENTIFICADOR",
    pnombre || ' ' || snombre || ' ' || apaterno AS "MECANICO",
    sueldo AS "SALARIO ACTUAL",
    (sueldo * 0.05) AS "AJUSTE",
    (sueldo + (sueldo * 0.05)) AS "SUELDO_REAJUSTADO"
FROM 
    MECANICO
WHERE 
    (sueldo BETWEEN 600000 AND 900000)
    OR cod_supervisor IS NULL
ORDER BY 
    "SALARIO ACTUAL" ASC, 
    "MECANICO" DESC;