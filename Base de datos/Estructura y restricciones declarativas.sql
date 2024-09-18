CREATE TABLE PROVEEDORES (
    nombre VARCHAR(50) NOT NULL,
    id INT NOT NULL,
    direccion VARCHAR(50) NOT NULL, --Tdireccion
    correo VARCHAR(50) NOT NULL --Tcorre
    );

CREATE TABLE BIENESOFRECIDOS (
    idBien INT NOT NULL,
    idServicio INT,
    idProducto INT,
    idProveedor INT NOT NULL
    );
 
CREATE TABLE PRODUCTOS (
    idProducto  INT NOT NULL,
    precio      DECIMAL(13,2) NOT NULL,  --TMoneda
    nombre      VARCHAR(50) NOT NULL,
    unidadesActuales INT NOT NULL
    );  
 
CREATE TABLE COMPRAS (
    numero INT NOT NULL,
    fecha DATE NOT NULL,
    nombreOficina VARCHAR(50) NOT NULL
    );
 
CREATE TABLE CARPETAS(
    idCarpeta INT NOT NULL,
    nombreOficina VARCHAR(50) NOT NULL,
    numeroCarpetas INT NOT NULL,
    descripcion VARCHAR(200),
    estado VARCHAR(50) NOT NULL
    );
 
CREATE TABLE DOCUMENTOSADJUNTOS(
    numeroDocumento INT NOT NULL,
    numeroHistoria INT NOT NULL,
    idEmpleado INT NOT NULL,
    nombreDocumento VARCHAR(50)
    );
 
CREATE TABLE CONTRATOS(
    numeroContrato INT NOT NULL,
    idCarpeta INT NOT NULL,
    objeto VARCHAR(75) NOT NULL,
    valor  DECIMAL(13,2) NOT NULL
    );
 
CREATE TABLE ORGANIZACIONES(
    idOrganizacion INT NOT NULL,
    nombre VARCHAR(50),
    nit INT NOT NULL,
    direccion VARCHAR(50) NOT NULL
    );

CREATE TABLE SERVICIOS (
    idServicio  INT NOT NULL,
    precio      DECIMAL(13,2) NOT NULL,  --TMoneda
    nombre      VARCHAR(20) NOT NULL,
    fechaPago   DATE,  --TFecha
    estado      CHAR(1) NOT NULL); --TEstado

CREATE TABLE LINEASCOMPRAS(
    idBien          INT NOT NULL,
    numeroCompra    INT NOT NULL,
    cantidad        INT NOT NULL);  --TCantidad

CREATE TABLE OFICINAS (
    nombre      VARCHAR(50) NOT NULL,
    presupuesto DECIMAL(13,2) NOT NULL,  --TMoneda
    encargado   INT NOT NULL);

CREATE TABLE HISTORIASLABORALES(
    numeroHistoria  INT NOT NULL,
    idEmpleado      INT NOT NULL,
    idCarpeta       INT NOT NULL);

CREATE TABLE EMPLEADOS (
    idEmpleado      INT NOT NULL,
    nombre          VARCHAR(20) NOT NULL,
    nombreOficina   VARCHAR(50) NOT NULL,
    idCarpeta       INT NOT NULL,
    correo          VARCHAR(30) NOT NULL,
    telefono        INT NOT NULL);

CREATE TABLE PROYECTOS (
    idProyecto     INT NOT NULL,
    idOrganizacion  INT NOT NULL,
    numeroContrato  INT NOT NULL,
    descripcion     VARCHAR(75) NOT NULL,
    fechaInicio     DATE NOT NULL,  --TFecha
    fechaFin        DATE);  --TFecha

CREATE TABLE TELEFONOS(
    telefono    INT NOT NULL,
    idEntidad   INT NOT NULL);

----------------------------------------------XTablas------------------------------------------
DROP TABLE TELEFONOS;
DROP TABLE PROYECTOS;
DROP TABLE CONTRATOS;
DROP TABLE LINEASCOMPRAS;
DROP TABLE BIENESOFRECIDOS;
DROP TABLE PROVEEDORES;
DROP TABLE PRODUCTOS;
DROP TABLE SERVICIOS;
DROP TABLE COMPRAS;
DROP TABLE DOCUMENTOSADJUNTOS;
DROP TABLE HISTORIASLABORALES;
DROP TABLE EMPLEADOS;
DROP TABLE CARPETAS;
DROP TABLE OFICINAS;
DROP TABLE ORGANIZACIONES;

------------------------------------------------PK---------------------------------------------
ALTER TABLE PROVEEDORES ADD CONSTRAINT PK_PROVEEDORES 
    PRIMARY KEY (id);
 
ALTER TABLE BIENESOFRECIDOS ADD CONSTRAINT PK_BIENESOFRECIDOS 
    PRIMARY KEY (idBien);
 
ALTER TABLE PRODUCTOS ADD CONSTRAINT PK_PRODUCTOS 
    PRIMARY KEY (idProducto);
 
ALTER TABLE COMPRAS ADD CONSTRAINT PK_COMPRAS 
    PRIMARY KEY (numero);
 
ALTER TABLE CARPETAS ADD CONSTRAINT PK_CARPETAS 
    PRIMARY KEY (idCarpeta);
 
ALTER TABLE DOCUMENTOSADJUNTOS ADD CONSTRAINT PK_DOCUMENTOSADJUNTOS 
    PRIMARY KEY (numerodocumento, numeroHistoria);
 
ALTER TABLE CONTRATOS ADD CONSTRAINT PK_CONTRATOS 
    PRIMARY KEY (numeroContrato);
 
ALTER TABLE ORGANIZACIONES ADD CONSTRAINT PK_ORGANIZACIONES 
    PRIMARY KEY (idOrganizacion);

ALTER TABLE SERVICIOS ADD CONSTRAINT PK_SERVICIOS
    PRIMARY KEY (idServicio);

ALTER TABLE LINEASCOMPRAS ADD CONSTRAINT PK_LINEASCOMPRAS
    PRIMARY KEY (numeroCompra,idBien);

ALTER TABLE OFICINAS ADD CONSTRAINT PK_OFICINAS
    PRIMARY KEY (nombre);

ALTER TABLE HISTORIASLABORALES ADD CONSTRAINT PK_HISTORIASLABORALES
    PRIMARY KEY (numeroHistoria, idEmpleado);

ALTER TABLE EMPLEADOS ADD CONSTRAINT PK_EMPLEADOS
    PRIMARY KEY (idEmpleado);

ALTER TABLE PROYECTOS ADD CONSTRAINT PK_PROYECTOS
    PRIMARY KEY (idProyecto);

ALTER TABLE TELEFONOS ADD CONSTRAINT PK_TELEFONOS
    PRIMARY KEY (telefono, idEntidad);


------------------------------------------------FK---------------------------------------------
ALTER TABLE BIENESOFRECIDOS ADD CONSTRAINT FK_BIENES_OFRECIDOS_SERVICIOS 
    FOREIGN KEY (idServicio) REFERENCES SERVICIOS(idServicio);
 
ALTER TABLE BIENESOFRECIDOS ADD CONSTRAINT FK_BIENES_OFRECIDOS_PRODUCTOS 
    FOREIGN KEY (idProducto) REFERENCES PRODUCTOS(idProducto);

ALTER TABLE BIENESOFRECIDOS ADD CONSTRAINT FK_BIENES_OFRECIDOS_PROVEEDORES 
    FOREIGN KEY (idProveedor) REFERENCES PROVEEDORES(id);
 
ALTER TABLE COMPRAS ADD CONSTRAINT FK_COMPRAS_OFICINAS 
    FOREIGN KEY (nombreOficina) REFERENCES OFICINAS(nombre);
 
ALTER TABLE CARPETAS ADD CONSTRAINT FK_CARPERTAS_OFICINAS 
    FOREIGN KEY (nombreOficina) REFERENCES OFICINAS(nombre);
 
ALTER TABLE DOCUMENTOSADJUNTOS ADD CONSTRAINT FK_DOCUMENTOS_ADJUNTOS_HISTORIAS 
    FOREIGN KEY (numeroHistoria, idEmpleado) REFERENCES HISTORIASLABORALES(numeroHistoria, idEmpleado);
 
ALTER TABLE CONTRATOS ADD CONSTRAINT FK_CONTRATOS_CARPETAS 
    FOREIGN KEY (idCarpeta) REFERENCES CARPETAS(idCarpeta);

ALTER TABLE LINEASCOMPRAS ADD CONSTRAINT FK_LINEASCOMPRAS_COMPRAS
    FOREIGN  KEY (numeroCompra) REFERENCES COMPRAS(numero);

ALTER TABLE LINEASCOMPRAS ADD CONSTRAINT FK_LINEASCOMPRAS_BIENES
    FOREIGN  KEY (idBien) REFERENCES BIENESOFRECIDOS(idBien);

ALTER TABLE HISTORIASLABORALES ADD CONSTRAINT FK_HISTORIASLABORALES_EMPLEADOS
    FOREIGN  KEY (idEmpleado) REFERENCES EMPLEADOS(idEmpleado);

ALTER TABLE HISTORIASLABORALES ADD CONSTRAINT FK_HISTORIASLABORALES_CARPETAS
    FOREIGN  KEY (idCarpeta) REFERENCES CARPETAS(idCarpeta);

ALTER TABLE EMPLEADOS ADD CONSTRAINT FK_EMPLEADOS_OFICINAS
    FOREIGN  KEY (nombreOficina) REFERENCES OFICINAS(nombre);

ALTER TABLE EMPLEADOS ADD CONSTRAINT FK_EMPLEADOS_CARPETA
    FOREIGN  KEY (idCarpeta) REFERENCES CARPETAS(idCarpeta);

ALTER TABLE PROYECTOS ADD CONSTRAINT FK_PROYECTOS_ORGANIZACIONES
    FOREIGN  KEY (idOrganizacion) REFERENCES ORGANIZACIONES(idOrganizacion);

ALTER TABLE PROYECTOS ADD CONSTRAINT FK_PROYECTOS_CONTRATOS
    FOREIGN  KEY (numeroContrato) REFERENCES CONTRATOS(numeroContrato);

ALTER TABLE TELEFONOS ADD CONSTRAINT FK_TELEFONOS_ORGANIZACIONES
    FOREIGN  KEY (idEntidad) REFERENCES ORGANIZACIONES(idOrganizacion);

------------------------------------------------UK---------------------------------------------
ALTER TABLE PROVEEDORES ADD CONSTRAINT 
    UK_PROVEEDORES UNIQUE (correo);
 
ALTER TABLE  ORGANIZACIONES ADD CONSTRAINT 
    UK_ORGANIZACIONES UNIQUE (nit);

ALTER TABLE EMPLEADOS ADD CONSTRAINT UK_EMPLEADOS1 
    UNIQUE (idCarpeta);

ALTER TABLE EMPLEADOS ADD CONSTRAINT UK_EMPLEADOS2
    UNIQUE (correo);

ALTER TABLE EMPLEADOS ADD CONSTRAINT UK_EMPLEADOS3
    UNIQUE (telefono);



--dominios


ALTER TABLE SERVICIOS ADD CONSTRAINT CH_SERVICIOS_TEstado
    CHECK(estado IN ('P','N')); -- P(ago) y N(o pago)

ALTER TABLE LINEASCOMPRAS ADD CONSTRAINT CH_LINEASCOMPRAS_TCantidad
    CHECK(cantidad >= 0);

ALTER TABLE PROVEEDORES ADD CONSTRAINT CH_PROVEEDORES_TDIRECCION
    CHECK(direccion LIKE '%#%-%');

ALTER TABLE PROVEEDORES ADD CONSTRAINT CH_PROVEEDORES_TCORREO
    CHECK(correo LIKE '%@%.%' AND  correo NOT LIKE '%@%@%');

ALTER TABLE PRODUCTOS ADD CONSTRAINT CH_PRODUCTOS_TCANTIDAD
    CHECK(unidadesActuales >= 0);

ALTER TABLE CARPETAS ADD CONSTRAINT CH_CARPETAS_TCANTIDAD
    CHECK(numeroCarpetas >= 0);
    
ALTER TABLE ORGANIZACIONES ADD CONSTRAINT CH_ORGANIZACIONES_TDIRECCION
    CHECK(direccion LIKE '%#%-%');




----------------------------------------------Poblar-------------------------------------------



--PoblarOK
--OFICINAS
INSERT INTO OFICINAS (nombre, encargado, presupuesto)
    VALUES ('Oficina de educacion', 123, 32000000.00);

INSERT INTO OFICINAS (nombre, encargado, presupuesto)
    VALUES ('Oficina de hacienda', 123, 32000000.00);

INSERT INTO OFICINAS (nombre, encargado, presupuesto)
    VALUES ('Oficina de desarrollo economico', 123, 32000000.00);

INSERT INTO OFICINAS (nombre, encargado, presupuesto)
    VALUES ('Oficina general', 123, 32000000.00);

INSERT INTO OFICINAS (nombre, encargado, presupuesto)
    VALUES ('Oficina de gobierno', 123, 32000000.00);

INSERT INTO OFICINAS (nombre, encargado, presupuesto)
    VALUES ('Oficina de control interno', 123, 32000000.00);

--PROVEEDORES
INSERT INTO PROVEEDORES (nombre, id, direccion, correo)
    VALUES ('Carlos S.A.', 1, 'AK 45 #205-6','algo.3lol@mail.com');

INSERT INTO PROVEEDORES (nombre, id, direccion, correo)
    VALUES ('Arotech Corporation',2,'Shasta Pass #3-41','lausting0@posterous.com');

INSERT INTO PROVEEDORES (nombre, id, direccion, correo)
    VALUES ('United Natural Foods Inc.',3,'2nd Plaza #53-13','mhenrichsg@wp.com');

INSERT INTO PROVEEDORES (nombre, id, direccion, correo)
    VALUES ('KAR Auction Services, Inc',4,'Buena Vista Street #11-185','lflaunderss@infoseek.co.jp');

INSERT INTO PROVEEDORES (nombre, id, direccion, correo)
    VALUES ('Lions Gate Entertainment Corporation',5,'Delladonna Place #2-7','oaddis14@bloomberg.com');

INSERT INTO PROVEEDORES (nombre, id, direccion, correo)
    VALUES ('Capitala Finance Corp.',6,'Del Sol Terrace #48-16','fbrugemann1b@trellian.com');

INSERT INTO PROVEEDORES (nombre, id, direccion, correo)
    VALUES ('MB Financial Inc.',7,'Ilene Drive #8-12','cconway1e@kickstarter.com');

INSERT INTO PROVEEDORES (nombre, id, direccion, correo)
    VALUES ('National Commerce Corporation',8,'Warrior Terrace #01-82','gbenoit1o@delicious.com');

INSERT INTO PROVEEDORES (nombre, id, direccion, correo)
    VALUES ('RAIT Financial Trust',9,'Acker Way #15-67','iblown1v@indiegogo.com');

INSERT INTO PROVEEDORES (nombre, id, direccion, correo)
    VALUES ('Universal Corporation',10,'Badeau Way #69-28','cmcasgill2k@mapy.cz');

INSERT INTO PROVEEDORES (nombre, id, direccion, correo)
    VALUES ('J P Morgan Chase & Co',11,'Rieder Circle #4-5','dgarman2o@cdc.gov');

INSERT INTO PROVEEDORES (nombre, id, direccion, correo)
    VALUES ('Aluminum Corporation of China Limited',12,'Magdeline Terrace #0-1','rturbat2s@mit.edu');

INSERT INTO PROVEEDORES (nombre, id, direccion, correo)
    VALUES ('MTS Systems Corporation',13,'Stone Corner Street #7-4','mbonnettc@nationalgeographic.com');

INSERT INTO PROVEEDORES (nombre, id, direccion, correo)
    VALUES ('AMERIPRISE FINANCIAL SERVICES, INC.',14,'Little Fleur Alley #13-99','dspeedingd@w3.org');

INSERT INTO PROVEEDORES (nombre, id, direccion, correo)
    VALUES ('GP Investments Acquisition Corp.',15,'Sherman Pass #4-3','dwhildere@woothemes.com');

INSERT INTO PROVEEDORES (nombre, id, direccion, correo)
    VALUES ('Trex Company, Inc.',16,'Mayer Circle #2-4','bmckinnonf@dagondesign.com');

INSERT INTO PROVEEDORES (nombre, id, direccion, correo)
    VALUES ('United Natural Foods, Inc.',17,'2nd Plaza #53-13','msqhenrichsg@wp.com');

INSERT INTO PROVEEDORES (nombre, id, direccion, correo)
    VALUES ('Embotelladora Andina S.A.',18,'Nobel Street #6-0','asnashallh@geocities.com');

INSERT INTO PROVEEDORES (nombre, id, direccion, correo)
    VALUES ('Cesca Therapeutics Inc.',19,'Waxwing Terrace #1-4','jtweedei@mozilla.com');

INSERT INTO PROVEEDORES (nombre, id, direccion, correo)
    VALUES ('Taro Pharmaceutical Industries Ltd.',20,'Maple Wood Circle #70-892','dknealej@wsj.com');

INSERT INTO PROVEEDORES (nombre, id, direccion, correo)
    VALUES ('Heritage Financial Corporation',21,'Sachs Circle #14-177','lhigfordk@unblog.fr');

INSERT INTO PROVEEDORES (nombre, id, direccion, correo)
    VALUES ('China Cord Blood Corporation',22,'Lakeland Alley #2-4','sshillakerl@newyorker.com');

INSERT INTO PROVEEDORES (nombre, id, direccion, correo)
    VALUES ('Rexnord Corporation',23,'Glacier Hill Avenue #9-55','tlampettm@mlb.com');

INSERT INTO PROVEEDORES (nombre, id, direccion, correo)
    VALUES ('Coty Inc.',24,'93 Surrey Crossing #9-3','averillon@springer.com');

INSERT INTO PROVEEDORES (nombre, id, direccion, correo)
    VALUES ('SharpSpring, Inc.',25,'Lakeland Park #60-031','hpartricko@goo.ne.jp');

--ORGANIZACIONES
INSERT INTO ORGANIZACIONES (idOrganizacion, nombre, nit, direccion)
    VALUES (1,'EA', 3653, 'AK 46 #204-7');

INSERT INTO ORGANIZACIONES (idOrganizacion, nombre, nit, direccion)
    VALUES (2,'Vornado Realty Trust',6583141,'Columbus Place #35-56');

INSERT INTO ORGANIZACIONES (idOrganizacion, nombre, nit, direccion)
    VALUES (3,'Morgan Stanley Emerging Markets Debt Fund, Inc.',14941219819, 'Larry Lane #213-7');

INSERT INTO ORGANIZACIONES (idOrganizacion, nombre, nit, direccion)
    VALUES (4,'Nuveen Core Equity Alpha Fund',1921816128290, 'Maryland Point #546-13');

INSERT INTO ORGANIZACIONES (idOrganizacion, nombre, nit, direccion)
    VALUES (5,'Oncobiologics, Inc.',48159156199, 'Corscot Center #426-32');

INSERT INTO ORGANIZACIONES (idOrganizacion, nombre, nit, direccion)
    VALUES (6,'Hamilton Lane Incorporated',7012207226,'Carey Trail #60-03');

INSERT INTO ORGANIZACIONES (idOrganizacion, nombre, nit, direccion)
    VALUES (7,'Grupo Financiero Galicia S.A.',25203187228,'Sutherland Point #0-55');

INSERT INTO ORGANIZACIONES (idOrganizacion, nombre, nit, direccion)
    VALUES (8,'Penns Woods Bancorp, Inc.',23412359231,'Bobwhite Center #69-92');

INSERT INTO ORGANIZACIONES (idOrganizacion, nombre, nit, direccion)
    VALUES (9,'Virtus Global Multi-Sector Income Fund',2071945876,'7#90-8 Reindahl Park');

INSERT INTO ORGANIZACIONES (idOrganizacion, nombre, nit, direccion)
    VALUES (10,'H&R Block, Inc.',376220564,'7#4-8 Clemons Pass');

INSERT INTO ORGANIZACIONES (idOrganizacion, nombre, nit, direccion)
    VALUES (11,'Blueknight Energy Partners L.P., L.L.C.',141751825,'#15-9 Dunning Road');

INSERT INTO ORGANIZACIONES (idOrganizacion, nombre, nit, direccion)
    VALUES (12,'MiMedx Group, Inc',15518549176,'#8-2 Carpenter Hill');

INSERT INTO ORGANIZACIONES (idOrganizacion, nombre, nit, direccion)
    VALUES (13,'Covisint Corporation',20920314187,'#43-20 Manley Parkway');

INSERT INTO ORGANIZACIONES (idOrganizacion, nombre, nit, direccion)
    VALUES (14,'Royal Bank Scotland plc (The)',169167141131,'#85-03 Brown Terrace');

INSERT INTO ORGANIZACIONES (idOrganizacion, nombre, nit, direccion)
    VALUES (15,'New Age Beverages Corporation',34238177100,'#00-89 Delladonna Lane');

INSERT INTO ORGANIZACIONES (idOrganizacion, nombre, nit, direccion)
    VALUES (16,'UMH Properties, Inc.',1210519236,'#1-3 Walton Street');

INSERT INTO ORGANIZACIONES (idOrganizacion, nombre, nit, direccion)
    VALUES (17,'Corium International, Inc.',124259124,'#72-90 Carey Hill');

INSERT INTO ORGANIZACIONES (idOrganizacion, nombre, nit, direccion)
    VALUES (18,'The GDL Fund',5722917673,'#22-84 Meadow Vale Crossing');

INSERT INTO ORGANIZACIONES (idOrganizacion, nombre, nit, direccion)
    VALUES (19,'Ashford Hospitality Trust Inc',1111131181,'#2-13 Shasta Center');

INSERT INTO ORGANIZACIONES (idOrganizacion, nombre, nit, direccion)
    VALUES (20,'Blackrock MuniYield California Fund, Inc.',15214051139,'#7-4 Ridgeway Parkway');

INSERT INTO ORGANIZACIONES (idOrganizacion, nombre, nit, direccion)
    VALUES (21,'VanEck Vectors Pharmaceutical ETF',821819797,'#30-15 Sauthoff Hill');

INSERT INTO ORGANIZACIONES (idOrganizacion, nombre, nit, direccion)
    VALUES (22,'Wabco Holdings Inc.',1271633133,'#20-811 Arizona Plaza');

INSERT INTO ORGANIZACIONES (idOrganizacion, nombre, nit, direccion)
    VALUES (23,'Invesco High Income 2023 Target Term Fund',9421323,'#42-95 Emmet Lane');

INSERT INTO ORGANIZACIONES (idOrganizacion, nombre, nit, direccion)
    VALUES (24,'PDC Energy, Inc.',242112232193,'#8-5 Carey Drive');

INSERT INTO ORGANIZACIONES (idOrganizacion, nombre, nit, direccion)
    VALUES (25,'Air Products and Chemicals, Inc.',14646348,'#13-8 Cambridge Point');

--PRODUCTOS
INSERT INTO PRODUCTOS(idProducto, precio, nombre ,unidadesActuales) 
    VALUES(1, 4.32, 'manzana', 7);

INSERT INTO PRODUCTOS(idProducto, precio, nombre ,unidadesActuales) 
    VALUES(2, 5.72, 'luctus', 30);

INSERT INTO PRODUCTOS(idProducto, precio, nombre ,unidadesActuales) 
    VALUES(3, 8.07, 'donec', 11);

INSERT INTO PRODUCTOS(idProducto, precio, nombre ,unidadesActuales) 
    VALUES(4, 2.49, 'accumsan', 44);

INSERT INTO PRODUCTOS(idProducto, precio, nombre ,unidadesActuales) 
    VALUES(5, 1.4, 'ligula', 17);

INSERT INTO PRODUCTOS(idProducto, precio, nombre ,unidadesActuales) 
    VALUES(6, 3.16, 'lacinia', 6);

INSERT INTO PRODUCTOS(idProducto, precio, nombre ,unidadesActuales) 
    VALUES(7, 4.16, 'suscipit', 22);

INSERT INTO PRODUCTOS(idProducto, precio, nombre ,unidadesActuales) 
    VALUES(8, 1.98, 'ante', 14);

INSERT INTO PRODUCTOS(idProducto, precio, nombre ,unidadesActuales) 
    VALUES(9, 8.83, 'librero', 32);

INSERT INTO PRODUCTOS(idProducto, precio, nombre ,unidadesActuales) 
    VALUES(10, 1.21, 'cubilia', 20);

INSERT INTO PRODUCTOS(idProducto, precio, nombre ,unidadesActuales) 
    VALUES(11, 7.09, 'nulla', 41);

INSERT INTO PRODUCTOS(idProducto, precio, nombre ,unidadesActuales) 
    VALUES(12, 6.59, 'sem', 27);

INSERT INTO PRODUCTOS(idProducto, precio, nombre ,unidadesActuales) 
    VALUES(13, 4.87, 'amet', 3);

INSERT INTO PRODUCTOS(idProducto, precio, nombre ,unidadesActuales) 
    VALUES(14, 4.26, 'quis', 4);

INSERT INTO PRODUCTOS(idProducto, precio, nombre ,unidadesActuales) 
    VALUES(15, 5.95, 'sit', 37);

INSERT INTO PRODUCTOS(idProducto, precio, nombre ,unidadesActuales) 
    VALUES(16, 2.18, 'sapien', 0);

INSERT INTO PRODUCTOS(idProducto, precio, nombre ,unidadesActuales) 
    VALUES(17, 7.85, 'non', 50);

INSERT INTO PRODUCTOS(idProducto, precio, nombre ,unidadesActuales) 
    VALUES(18, 1.25, 'pellentesque', 13);

INSERT INTO PRODUCTOS(idProducto, precio, nombre ,unidadesActuales) 
    VALUES(19, 9.48, 'luctus', 23);

INSERT INTO PRODUCTOS(idProducto, precio, nombre ,unidadesActuales) 
    VALUES(20, 6.76, 'nam', 18);

INSERT INTO PRODUCTOS(idProducto, precio, nombre ,unidadesActuales) 
    VALUES(21, 5.88, 'dui', 24);

INSERT INTO PRODUCTOS(idProducto, precio, nombre ,unidadesActuales) 
    VALUES(22, 6.6, 'parturient', 15);

INSERT INTO PRODUCTOS(idProducto, precio, nombre ,unidadesActuales) 
    VALUES(23, 4.72, 'semper', 21);

INSERT INTO PRODUCTOS(idProducto, precio, nombre ,unidadesActuales) 
    VALUES(24, 8.83, 'dignissim', 27);

INSERT INTO PRODUCTOS(idProducto, precio, nombre ,unidadesActuales) 
    VALUES(25, 0.76, 'metus', 9);

--SERVICIOS
INSERT INTO SERVICIOS(idServicio, precio, nombre, fechaPago, estado) 
    VALUES(1, 4.37, 'luz', '5/11/2022', 'P');

INSERT INTO SERVICIOS(idServicio, precio, nombre, fechaPago, estado) 
    VALUES(2, 1.75, 'agua', '01/3/2022', 'N');

INSERT INTO SERVICIOS(idServicio, precio, nombre, fechaPago, estado) 
    VALUES(3, 8.79, 'gas', '30/12/2022', 'N');

INSERT INTO SERVICIOS(idServicio, precio, nombre, fechaPago, estado) 
    VALUES(4, 6.95, 'limpieza', '7/10/2022', 'P');

INSERT INTO SERVICIOS(idServicio, precio, nombre, fechaPago, estado) 
    VALUES(5, 3.48, 'internet', '15/8/2022', 'N');

INSERT INTO SERVICIOS(idServicio, precio, nombre, fechaPago, estado) 
    VALUES(6, 9.54, 'telefonía', '13/9/2022', 'P');

INSERT INTO SERVICIOS(idServicio, precio, nombre, fechaPago, estado) 
    VALUES(7, 5.52, 'banco', '19/7/2022', 'P');

INSERT INTO SERVICIOS(idServicio, precio, nombre, fechaPago, estado) 
    VALUES(8, 2, 'plomeria', '4/3/2022', 'N');

INSERT INTO SERVICIOS(idServicio, precio, nombre, fechaPago, estado) 
    VALUES(9, 5.21, 'auditoria', '6/7/2022', 'P');

INSERT INTO SERVICIOS(idServicio, precio, nombre, fechaPago, estado) 
    VALUES(10, 6.95, 'reparacion', '17/6/2022', 'N');


--BIENESOFRECIDOS

INSERT INTO BIENESOFRECIDOS(idBien, idProducto, idProveedor) 
    VALUES (1, 17,1);

INSERT INTO BIENESOFRECIDOS(idBien, idServicio, idProveedor) 
    VALUES (6, 10 ,2);

INSERT INTO BIENESOFRECIDOS(idBien,  idProducto, idProveedor) 
    VALUES (8, 15 ,3);

INSERT INTO BIENESOFRECIDOS(idBien, idProducto, idProveedor) 
    VALUES (11, 13 ,4);

INSERT INTO BIENESOFRECIDOS(idBien, idProducto, idProveedor) 
    VALUES (9, 12 ,5);

INSERT INTO BIENESOFRECIDOS(idBienidBien,  idProducto, idProveedor) 
    VALUES (3, 14 ,6);

INSERT INTO BIENESOFRECIDOS(idBien, idProducto, idProveedor) 
    VALUES (5, 17 ,7);

INSERT INTO BIENESOFRECIDOS(idBien, idProducto, idProveedor) 
    VALUES (3, 14 ,8);

INSERT INTO BIENESOFRECIDOS(idBien, idServicio, idProveedor) 
    VALUES (21, 1, 9);

INSERT INTO BIENESOFRECIDOS(idBien, idServicio,idProveedor) 
    VALUES (6, 2, 10);

INSERT INTO BIENESOFRECIDOS(idBien, idServicio, idProveedor) 
    VALUES (16, 3, 11);

INSERT INTO BIENESOFRECIDOS(idBien, idServicio,  idProveedor) 
    VALUES (10, 5, 12);

INSERT INTO BIENESOFRECIDOS(idBien, idServicio, idProveedor) 
    VALUES (20, 7, 13);

INSERT INTO BIENESOFRECIDOS(idBien, idServicio, idProveedor) 
    VALUES (9, 4, 14);

INSERT INTO BIENESOFRECIDOS(idBien, idServicio, idProveedor) 
    VALUES (7, 8, 15);

INSERT INTO BIENESOFRECIDOS(idBien, idServicio, idProveedor) 
    VALUES (13, 7, 16);

INSERT INTO BIENESOFRECIDOS(idBien,  idServicio, idProveedor) 
    VALUES (25, 14, 17);

INSERT INTO BIENESOFRECIDOS(idBien, idServicio, idProveedor) 
    VALUES (8, 8, 18);

INSERT INTO BIENESOFRECIDOS(idBien, idServicio, idProveedor) 
    VALUES (5, 4, 19);

INSERT INTO BIENESOFRECIDOS(idBien, idServicio, idProveedor) 
    VALUES (3, 6, 20);

INSERT INTO BIENESOFRECIDOS(idBien, idServicio, idProveedor) 
    VALUES (17, 5, 21);
idBien
INSERT INTO BIENESOFRECIDOS(idBien, idServicio, idProveedor) 
    VALUES (4, 1, 22);

INSERT INTO BIENESOFRECIDOS(idBien, idServicio,, idProveedor) 
    VALUES (5, 2, 23);

INSERT INTO BIENESOFRECIDOS(idBien, idServicio, idProveedor) 
    VALUES (9, 3, 24);

INSERT INTO BIENESOFRECIDOS(idBien, idServicio, idProveedor) 
    VALUES (2, 8, 25);


--LINEASCOMPRAS
INSERT INTO LINEASCOMPRAS(numeroCompra, idProducto, cantidad)
    VALUES(1234, 1, 7);



--COMPRAS
INSERT INTO COMPRAS(numero,fecha,nombreOficina) 
    VALUES(1,'1/2/2023','Oficina de educacion');

INSERT INTO COMPRAS(numero,fecha,nombreOficina) 
    VALUES(2,'27/04/2022','Oficina de educacion');

INSERT INTO COMPRAS(numero,fecha,nombreOficina) 
    VALUES(3,'20/09/2022','Oficina de educacion'); 

INSERT INTO COMPRAS(numero,fecha,nombreOficina) 
    VALUES(4,'19/06/2022','Oficina de educacion');

INSERT INTO COMPRAS(numero,fecha,nombreOficina) 
    VALUES(5,'12/8/2022','Oficina de educacion');

INSERT INTO COMPRAS(numero,fecha,nombreOficina) 
    VALUES(6,'12/12/2022','Oficina de hacienda');

INSERT INTO COMPRAS(numero,fecha,nombreOficina) 
    VALUES(7,'21/01/2023','Oficina de hacienda');

INSERT INTO COMPRAS(numero,fecha,nombreOficina) 
    VALUES(8,'30/10/2022','Oficina de hacienda'); 

INSERT INTO COMPRAS(numero,fecha,nombreOficina) 
    VALUES(9,'9/7/2022','Oficina de hacienda');

INSERT INTO COMPRAS(numero,fecha,nombreOficina) 
    VALUES(10,'13/10/2022','Oficina de hacienda');
    
INSERT INTO COMPRAS(numero,fecha,nombreOficina) 
    VALUES(11,'31/12/2022','Oficina de desarrollo economico');

INSERT INTO COMPRAS(numero,fecha,nombreOficina) 
    VALUES(12,'19/05/2022','Oficina de desarrollo economico');

INSERT INTO COMPRAS(numero,fecha,nombreOficina) 
    VALUES(13,'9/7/2022','Oficina de desarrollo economico'); 

INSERT INTO COMPRAS(numero,fecha,nombreOficina) 
    VALUES(14,'10/6/2022','Oficina de desarrollo economico');

INSERT INTO COMPRAS(numero,fecha,nombreOficina) 
    VALUES(15,'2/10/2022','Oficina de desarrollo economico');
    
INSERT INTO COMPRAS(numero,fecha,nombreOficina) 
    VALUES(16,'23/08/2022','Oficina general');

INSERT INTO COMPRAS(numero,fecha,nombreOficina) 
    VALUES(17,'26/02/2023','Oficina general');

INSERT INTO COMPRAS(numero,fecha,nombreOficina) 
    VALUES(18,'25/05/2022','Oficina general'); 

INSERT INTO COMPRAS(numero,fecha,nombreOficina) 
    VALUES(19,'27/08/2022','Oficina general');

INSERT INTO COMPRAS(numero,fecha,nombreOficina) 
    VALUES(20,'18/09/2022','Oficina general');
    
INSERT INTO COMPRAS(numero,fecha,nombreOficina) 
    VALUES(21,'4/6/2022','Oficina de gobierno');

INSERT INTO COMPRAS(numero,fecha,nombreOficina) 
    VALUES(22,'25/06/2022','Oficina de gobierno');

INSERT INTO COMPRAS(numero,fecha,nombreOficina) 
    VALUES(23,'23/02/2023','Oficina de gobierno'); 

INSERT INTO COMPRAS(numero,fecha,nombreOficina) 
    VALUES(24,'7/3/2023','Oficina de gobierno');

INSERT INTO COMPRAS(numero,fecha,nombreOficina) 
    VALUES(25,'16/04/2023','Oficina de gobierno');
    
--CARPETAS
INSERT INTO CARPETAS(idCarpeta,nombreOficina,numeroCarpetas,descripcion,estado)
    VALUES(1,'Oficina de gobierno',4,'ornare consequat lectus in est risus auctor sed tristique in tempus sit amet sem fusce consequat','ultrices libero non mattis ');

INSERT INTO CARPETAS(idCarpeta,nombreOficina,numeroCarpetas,descripcion,estado)
    VALUES(2,'Oficina de gobierno',6,'sit amet sem fusce consequat nulla nisl nunc nisl duis bibendum felis sed interdum venenatis turpis enim blandit','integer tincidunt ante vel');

INSERT INTO CARPETAS(idCarpeta,nombreOficina,numeroCarpetas,descripcion,estado)
    VALUES(3,'Oficina de gobierno',3,'ut erat curabitur gravida nisi at nibh','Faltan documentos antecedentes');

INSERT INTO CARPETAS(idCarpeta,nombreOficina,numeroCarpetas,descripcion,estado)
    VALUES(4,'Oficina de gobierno',9,'velit eu est congue elementum in ','arcu libero rutrum ac lobortis vel dapibus at');

INSERT INTO CARPETAS(idCarpeta,nombreOficina,numeroCarpetas,descripcion,estado)
    VALUES(5,'Oficina de gobierno',2,'nonummy integer non velit donec diam neque vestibulum','et tempus semper est quam');

INSERT INTO CARPETAS(idCarpeta, nombreOficina,numeroCarpetas,descripcion,estado) 
    VALUES(6,'Oficina general',8,'platea dictumst aliquam augue quam sollicitudin vitae consectetuer eget rutrum at lorem integer tincidunt ante','Ok');

INSERT INTO CARPETAS(idCarpeta, nombreOficina,numeroCarpetas,descripcion,estado) 
    VALUES(7,'Oficina general',10,'varius nulla facilisi cras non velit nec nisi vulputate nonummy maecenas tincidunt lacus','elit ac nulla sed vel enim sit');

INSERT INTO CARPETAS(idCarpeta, nombreOficina,numeroCarpetas,descripcion,estado) 
    VALUES(8,'Oficina general',4,'dolor morbi vel lectus in quam fringilla rhoncus mauris enim leo rhoncus sed vestibulum sit amet cursus id','cubilia curae donec pharetra magna');

INSERT INTO CARPETAS(idCarpeta, nombreOficina,numeroCarpetas,descripcion,estado) 
    VALUES(9,'Oficina general',7,'luctus cum sociis natoque penatibus et magnis dis parturient montes nascetur ridiculus mus vivamus vestibulum sagittis sapien cum sociis natoque','Ok');

INSERT INTO CARPETAS(idCarpeta, nombreOficina,numeroCarpetas,estado) 
    VALUES(10,'Oficina general',5,'luctus et ultrices posuere cubilia curae nulla');

INSERT INTO CARPETAS(idCarpeta, nombreOficina,numeroCarpetas,descripcion,estado) 
    VALUES(11,'Oficina de desarrollo economico',1,'curae duis faucibus accumsan odio curabitur convallis duis consequat dui','cubilia curae donec pharetra magna');

INSERT INTO CARPETAS(idCarpeta, nombreOficina,numeroCarpetas,estado) 
    VALUES(12,'Oficina de desarrollo economico',11,'nunc proin at turpis a');

INSERT INTO CARPETAS(idCarpeta, nombreOficina,numeroCarpetas,descripcion,estado) 
    VALUES(13,'Oficina de desarrollo economico',4,'tincidunt eget tempus vel pede morbi porttitor lorem id ligula suspendisse ornare consequat lectus in','Ok');

INSERT INTO CARPETAS(idCarpeta, nombreOficina,numeroCarpetas,estado) 
    VALUES(14,'Oficina de desarrollo economico',9,'nisl duis ac nibh fusce lacus');

INSERT INTO CARPETAS(idCarpeta, nombreOficina,numeroCarpetas,descripcion,estado) 
    VALUES(15,'Oficina de desarrollo economico',3,'vestibulum quam sapien varius ut blandit non interdum in ante vestibulum ante ipsum primis in faucibus orci','justo morbi ut odio cras');

INSERT INTO CARPETAS(idCarpeta, nombreOficina,numeroCarpetas,estado) 
    VALUES(16,'Oficina de hacienda',2,'ultrices phasellus id sapien in');

INSERT INTO CARPETAS(idCarpeta, nombreOficina,numeroCarpetas,descripcion,estado) 
    VALUES(17,'Oficina de hacienda',2,'cursus id turpis integer aliquet massa id lobortis convallis tortor','dolor morbi vel lectus in');

INSERT INTO CARPETAS(idCarpeta, nombreOficina,numeroCarpetas,estado) 
    VALUES(18,'Oficina de hacienda',1,'arcu sed augue aliquam erat');

INSERT INTO CARPETAS(idCarpeta, nombreOficina,numeroCarpetas,estado) 
    VALUES(19,'Oficina de hacienda',8,'congue diam id ornare imperdiet');

INSERT INTO CARPETAS(idCarpeta, nombreOficina,numeroCarpetas,estado) 
    VALUES(20,'Oficina de hacienda',16,'est congue elementum in hac');

INSERT INTO CARPETAS(idCarpeta, nombreOficina,numeroCarpetas,descripcion,estado) 
    VALUES(21,'Oficina de educacion',1,'molestie lorem quisque ut erat curabitur gravida nisi at nibh in hac','Ok');

INSERT INTO CARPETAS(idCarpeta, nombreOficina,numeroCarpetas,descripcion,estado) 
    VALUES(22,'Oficina de educacion',6,'quis lectus suspendisse potenti in eleifend quam a odio in hac habitasse platea dictumst maecenas ut','Okelit ac nulla sed vel enim sit amet');

INSERT INTO CARPETAS(idCarpeta, nombreOficina,numeroCarpetas,descripcion,estado) 
    VALUES(23,'Oficina de educacion',9,'vestibulum ac est lacinia nisi venenatis tristique fusce congue diam id ornare imperdiet','ultricies eu nibh quisque id justo');

INSERT INTO CARPETAS(idCarpeta, nombreOficina,numeroCarpetas,estado) 
    VALUES(24,'Oficina de educacion',14,'Ok');

INSERT INTO CARPETAS(idCarpeta, nombreOficina,numeroCarpetas,estado) 
    VALUES(25,'Oficina de educacion',7,'sed lacus morbi sem mauris');

INSERT INTO CARPETAS(idCarpeta,nombreOficina,numeroCarpetas,descripcion,estado)
    VALUES(26,'Oficina de gobierno',4,'ut erat curabitur gravida nisi at nibh','ultrices libero non mattis ');

INSERT INTO CARPETAS(idCarpeta,nombreOficina,numeroCarpetas,descripcion,estado)
    VALUES(27,'Oficina de gobierno',6,'libero non mattis pulvinar nulla pede ullamcorper augue a suscipit','integer tincidunt ante vel');

INSERT INTO CARPETAS(idCarpeta,nombreOficina,numeroCarpetas,descripcion,estado)
    VALUES(28,'Oficina de gobierno',3,'dolor morbi vel lectus in quam fringilla rhoncus mauris enim leo rhoncus sed vestibulum sit amet cursus id','Faltan documentos antecedentes');

INSERT INTO CARPETAS(idCarpeta,nombreOficina,numeroCarpetas,descripcion,estado)
    VALUES(29,'Oficina de gobierno',9,'tincidunt eget tempus vel pede morbi porttitor lorem id ligula suspendisse ornare consequat lectus in','arcu libero rutrum ac lobortis vel dapibus at');

INSERT INTO CARPETAS(idCarpeta,nombreOficina,numeroCarpetas,descripcion,estado)
    VALUES(30,'Oficina de gobierno',2,'arcu sed augue aliquam erat volutpat in congue','et tempus semper est quam');

INSERT INTO CARPETAS(idCarpeta, nombreOficina,numeroCarpetas,descripcion,estado) 
    VALUES(31,'Oficina general',8,'velit eu est congue elementum in hac habitasse platea','Ok');

INSERT INTO CARPETAS(idCarpeta, nombreOficina,numeroCarpetas,descripcion,estado) 
    VALUES(32,'Oficina general',10,'vproin leo odio porttitor id consequat in consequat ut nulla sed accumsan felis ut at dolor','elit ac nulla sed vel enim sit');

INSERT INTO CARPETAS(idCarpeta, nombreOficina,numeroCarpetas,descripcion,estado) 
    VALUES(33,'Oficina general',4,'dui luctus rutrum nulla tellus in','cubilia curae donec pharetra magna');

INSERT INTO CARPETAS(idCarpeta, nombreOficina,numeroCarpetas,descripcion,estado) 
    VALUES(34,'Oficina general',7,'lectus vestibulum quam sapien varius ut blandit non interdum in ante','Ok');

INSERT INTO CARPETAS(idCarpeta, nombreOficina,numeroCarpetas,estado) 
    VALUES(35,'Oficina general',5,'luctus et ultrices posuere cubilia curae nulla');

INSERT INTO CARPETAS(idCarpeta, nombreOficina,numeroCarpetas,descripcion,estado) 
    VALUES(36,'Oficina de desarrollo economico',1,'vitae consectetuer eget rutrum at lorem integer tincidunt ante vel ipsum','cubilia curae donec pharetra magna');

INSERT INTO CARPETAS(idCarpeta, nombreOficina,numeroCarpetas,estado) 
    VALUES(37,'Oficina de desarrollo economico',11,'nunc proin at turpis a');

INSERT INTO CARPETAS(idCarpeta, nombreOficina,numeroCarpetas,descripcion,estado) 
    VALUES(38,'Oficina de desarrollo economico',4,'nisl nunc rhoncus dui vel sem sed','Ok');

INSERT INTO CARPETAS(idCarpeta, nombreOficina,numeroCarpetas,estado) 
    VALUES(39,'Oficina de desarrollo economico',9,'nisl duis ac nibh fusce lacus');

INSERT INTO CARPETAS(idCarpeta, nombreOficina,numeroCarpetas,descripcion,estado) 
    VALUES(40,'Oficina de desarrollo economico',3,'lacinia aenean sit amet justo morbi ut odio cras mi pede','justo morbi ut odio cras');

INSERT INTO CARPETAS(idCarpeta, nombreOficina,numeroCarpetas,estado) 
    VALUES(41,'Oficina de hacienda',2,'nisl duis ac nibh fusce lacus');

INSERT INTO CARPETAS(idCarpeta, nombreOficina,numeroCarpetas,descripcion,estado) 
    VALUES(42,'Oficina de hacienda',2,'nunc proin at turpis a','dolor morbi vel lectus in');

INSERT INTO CARPETAS(idCarpeta, nombreOficina,numeroCarpetas,estado) 
    VALUES(43,'Oficina de hacienda',1,'viverra eget congue eget semper rutrum nulla');

INSERT INTO CARPETAS(idCarpeta, nombreOficina,numeroCarpetas,estado) 
    VALUES(44,'Oficina de hacienda',8,'congue diam id ornare imperdiet');

INSERT INTO CARPETAS(idCarpeta, nombreOficina,numeroCarpetas,estado) 
    VALUES(45,'Oficina de hacienda',16,'justo morbi ut odio cras');

INSERT INTO CARPETAS(idCarpeta, nombreOficina,numeroCarpetas,descripcion,estado) 
    VALUES(46,'Oficina de educacion',1,'venenatis non sodales sed tincidunt eu ','Ok');

INSERT INTO CARPETAS(idCarpeta, nombreOficina,numeroCarpetas,descripcion,estado) 
    VALUES(47,'Oficina de educacion',6,'ultrices phasellus id sapien in','Okelit ac nulla sed vel enim sit amet');

INSERT INTO CARPETAS(idCarpeta, nombreOficina,numeroCarpetas,descripcion,estado) 
    VALUES(48,'Oficina de educacion',9,'vdiam erat fermentum justo nec condimentum neque sapien','ultricies eu nibh quisque id justo');

INSERT INTO CARPETAS(idCarpeta, nombreOficina,numeroCarpetas,estado) 
    VALUES(49,'Oficina de educacion',14,'aliquet massa id lobortis convallis tortor');

INSERT INTO CARPETAS(idCarpeta, nombreOficina,numeroCarpetas,estado) 
    VALUES(50,'Oficina de educacion',7,'nunc purus phasellus in felis donec');

--TELEFONOS
INSERT INTO TELEFONOS(telefono, idEntidad) 
    VALUES(3144587899,1);

INSERT INTO TELEFONOS(telefono, idEntidad) 
    VALUES(7779226924,2);

INSERT INTO TELEFONOS(telefono, idEntidad) 
    VALUES(6398386657,3);

INSERT INTO TELEFONOS(telefono, idEntidad) 
    VALUES(2738637043,4);

INSERT INTO TELEFONOS(telefono, idEntidad) 
    VALUES(1678005172,5);

INSERT INTO TELEFONOS(telefono, idEntidad) 
    VALUES(5008147771,6);

INSERT INTO TELEFONOS(telefono, idEntidad) 
    VALUES(1244412625,7);

INSERT INTO TELEFONOS(telefono, idEntidad) 
    VALUES(2135935281,8);

INSERT INTO TELEFONOS(telefono, idEntidad) 
    VALUES(4212186124,9);

INSERT INTO TELEFONOS(telefono, idEntidad) 
    VALUES(7237514156,10);

INSERT INTO TELEFONOS(telefono, idEntidad) 
    VALUES(2836022054,11);

INSERT INTO TELEFONOS(telefono, idEntidad) 
    VALUES(8225296023,12);

INSERT INTO TELEFONOS(telefono, idEntidad) 
    VALUES(2063569290,13);

INSERT INTO TELEFONOS(telefono, idEntidad) 
    VALUES(4264173682,14);

INSERT INTO TELEFONOS(telefono, idEntidad) 
    VALUES(1216354655,15);

INSERT INTO TELEFONOS(telefono, idEntidad) 
    VALUES(4752060036,16);

INSERT INTO TELEFONOS(telefono, idEntidad) 
    VALUES(2567548358,17);

INSERT INTO TELEFONOS(telefono, idEntidad) 
    VALUES(7202014113,18);

INSERT INTO TELEFONOS(telefono, idEntidad) 
    VALUES(3943330122,19);

INSERT INTO TELEFONOS(telefono, idEntidad) 
    VALUES(5431398987,20);

INSERT INTO TELEFONOS(telefono, idEntidad) 
    VALUES(7529545013,21);

INSERT INTO TELEFONOS(telefono, idEntidad) 
    VALUES(7148384373,22);

INSERT INTO TELEFONOS(telefono, idEntidad) 
    VALUES(9806385875,23);

INSERT INTO TELEFONOS(telefono, idEntidad) 
    VALUES(3156014723,24);

INSERT INTO TELEFONOS(telefono, idEntidad) 
    VALUES(1982291005,25);

--CONTRATOS
INSERT INTO CONTRATOS(numeroContrato,idCarpeta,objeto,valor) 
    VALUES(1,25,'semper est quam pharetra magna ac',61304.11);

INSERT INTO CONTRATOS(numeroContrato,idCarpeta,objeto,valor) 
    VALUES(2,24,'sociis natoque penatibus',10452.28);

INSERT INTO CONTRATOS(numeroContrato,idCarpeta,objeto,valor) 
    VALUES(3,23,'nisi eu orci mauris lacinia',71774.98);

INSERT INTO CONTRATOS(numeroContrato,idCarpeta,objeto,valor) 
    VALUES(4,22,'vel ipsum praesent blandit lacinia erat vestibulum',20225.16);

INSERT INTO CONTRATOS(numeroContrato,idCarpeta,objeto,valor) 
    VALUES(5,21,'nibh quisque id justo sit amet',75613.06);

INSERT INTO CONTRATOS(numeroContrato,idCarpeta,objeto,valor) 
    VALUES(6,20,'suscipit ligula in',15086.21);

INSERT INTO CONTRATOS(numeroContrato,idCarpeta,objeto,valor) 
    VALUES(7,19,'duis consequat dui nec nisi volutpat eleifend',38223.11);

INSERT INTO CONTRATOS(numeroContrato,idCarpeta,objeto,valor) 
    VALUES(8,18,'tempus semper est quam',49390.44);

INSERT INTO CONTRATOS(numeroContrato,idCarpeta,objeto,valor) 
    VALUES(9,17,'quisque arcu libero rutrum ac lobortis vel',99178.97);

INSERT INTO CONTRATOS(numeroContrato,idCarpeta,objeto,valor) 
    VALUES(10,16,'massa tempor convallis nulla neque libero convallis',55752.75);

INSERT INTO CONTRATOS(numeroContrato,idCarpeta,objeto,valor) 
    VALUES(11,15,'odio donec vitae nisi nam ultrices libero',3486.35);

INSERT INTO CONTRATOS(numeroContrato,idCarpeta,objeto,valor) 
    VALUES(12,14,'suspendisse accumsan tortor quis',83552.2);

INSERT INTO CONTRATOS(numeroContrato,idCarpeta,objeto,valor) 
    VALUES(13,13,'habitasse platea dictumst maecenas ut massa quis',40242.82);

INSERT INTO CONTRATOS(numeroContrato,idCarpeta,objeto,valor) 
    VALUES(14,12,'ac est lacinia nisi venenatis tristique',87308);

INSERT INTO CONTRATOS(numeroContrato,idCarpeta,objeto,valor) 
    VALUES(15,11,'sed ante vivamus',75122.09);

INSERT INTO CONTRATOS(numeroContrato,idCarpeta,objeto,valor) 
    VALUES(16,10,'rutrum neque aenean auctor gravida',8558.89);

INSERT INTO CONTRATOS(numeroContrato,idCarpeta,objeto,valor) 
    VALUES(17,9,'eu orci mauris lacinia sapien quis',1710.63);

INSERT INTO CONTRATOS(numeroContrato,idCarpeta,objeto,valor) 
    VALUES(18,8,'dui nec nisi volutpat eleifend',72766.16);

INSERT INTO CONTRATOS(numeroContrato,idCarpeta,objeto,valor) 
    VALUES(19,7,'sed vestibulum sit amet',75830.22);

INSERT INTO CONTRATOS(numeroContrato,idCarpeta,objeto,valor) 
    VALUES(20,6,'cum sociis natoque penatibus et magnis dis',55503.85);

INSERT INTO CONTRATOS(numeroContrato,idCarpeta,objeto,valor) 
    VALUES(21,5,'sociis natoque penatibus et magnis dis',33678.04);

INSERT INTO CONTRATOS(numeroContrato,idCarpeta,objeto,valor) 
    VALUES(22,4,'augue vestibulum rutrum rutrum',40478);

INSERT INTO CONTRATOS(numeroContrato,idCarpeta,objeto,valor) 
    VALUES(23,3,'quam sollicitudin vitae',69476.06);

INSERT INTO CONTRATOS(numeroContrato,idCarpeta,objeto,valor) 
    VALUES(24,2,'vestibulum ante ipsum primis in faucibus',38092.89);

INSERT INTO CONTRATOS(numeroContrato,idCarpeta,objeto,valor) 
    VALUES(25,1,'Pintar un ladrillo',46316.61);

--PROYECTOS
INSERT INTO PROYECTOS(idProyecto,idOrganizacion,numeroContrato,descripcion,fechainicio, fechaFin) 
    VALUES(1,7,3,'neque aenean auctor','15/07/2022', '29/04/2023');

INSERT INTO PROYECTOS(idProyecto,idOrganizacion,numeroContrato,descripcion,fechainicio, fechaFin) 
    VALUES(2,4,5,'in leo maecenas pulvinar lobortis','20/11/2022', '03/04/2023');

INSERT INTO PROYECTOS(idProyecto,idOrganizacion,numeroContrato,descripcion,fechainicio, fechaFin) 
    VALUES(3,10,2,'condimentum neque sapien placerat ante','21/09/2022', '29/09/2023');

INSERT INTO PROYECTOS(idProyecto,idOrganizacion,numeroContrato,descripcion,fechainicio, fechaFin) 
    VALUES(4,3,9,'curae nulla dapibus dolor','17/03/2023', '23/06/2023');

INSERT INTO PROYECTOS(idProyecto,idOrganizacion,numeroContrato,descripcion,fechainicio, fechaFin) 
    VALUES(5,12,20,'justo maecenas rhoncus aliquam lacus','6/1/2023', '3/8/2023');

INSERT INTO PROYECTOS(idProyecto,idOrganizacion,numeroContrato,descripcion,fechainicio, fechaFin) 
    VALUES(6,6,7,'donec dapibus duis','17/01/2023', '30/06/2023');

INSERT INTO PROYECTOS(idProyecto,idOrganizacion,numeroContrato,descripcion,fechainicio, fechaFin) 
    VALUES(7,7,9,'tortor sollicitudin mi sit','13/08/2022', '14/09/2023');

INSERT INTO PROYECTOS(idProyecto,idOrganizacion,numeroContrato,descripcion,fechainicio) 
    VALUES(8,8,10,'faucibus orci luctus','14/04/2015');

INSERT INTO PROYECTOS(idProyecto,idOrganizacion,numeroContrato,descripcion,fechainicio) 
    VALUES(9,22,15,'praesent blandit lacinia erat vestibulum','14/04/2015');

INSERT INTO PROYECTOS(idProyecto,idOrganizacion,numeroContrato,descripcion,fechainicio) 
    VALUES(10,17,13,'suspendisse potenti nullam porttitor lacus','14/04/2015');

INSERT INTO PROYECTOS(idProyecto,idOrganizacion,numeroContrato,descripcion,fechainicio, fechaFin) 
    VALUES(11,11,13,'id sapien in sapien iaculis','14/12/2022', '29/05/2023');

INSERT INTO PROYECTOS(idProyecto,idOrganizacion,numeroContrato,descripcion,fechainicio, fechaFin) 
    VALUES(12,6,25,'arcu libero rutrum ac lobortis','2/4/2023', '1/7/2023');

INSERT INTO PROYECTOS(idProyecto,idOrganizacion,numeroContrato,descripcion,fechainicio, fechaFin) 
    VALUES(13,4,21,'odio curabitur convallis duis consequat','5/5/2022', '23/08/2023');

INSERT INTO PROYECTOS(idProyecto,idOrganizacion,numeroContrato,descripcion,fechainicio) 
    VALUES(14,13,20,'cubilia curae mauris viverra','14/04/2015');

INSERT INTO PROYECTOS(idProyecto,idOrganizacion,numeroContrato,descripcion,fechainicio, fechaFin) 
    VALUES(15,5,13,'maecenas pulvinar lobortis','25/09/2022', '26/08/2023');

INSERT INTO PROYECTOS(idProyecto,idOrganizacion,numeroContrato,descripcion,fechainicio, fechaFin) 
    VALUES(16,6,18,'neque duis bibendum morbi','16/01/2023', '11/7/2023');

INSERT INTO PROYECTOS(idProyecto,idOrganizacion,numeroContrato,descripcion,fechainicio, fechaFin) 
    VALUES(17,3,4,'dis parturient montes','3/8/2022', '24/08/2023');

INSERT INTO PROYECTOS(idProyecto,idOrganizacion,numeroContrato,descripcion,fechainicio) 
    VALUES(18,12,5,'molestie sed justo pellentesque','14/04/2015');

INSERT INTO PROYECTOS(idProyecto,idOrganizacion,numeroContrato,descripcion,fechainicio, fechaFin) 
    VALUES(19,16,9,'non lectus aliquam sit','3/7/2022', '29/05/2023');

INSERT INTO PROYECTOS(idProyecto,idOrganizacion,numeroContrato,descripcion,fechainicio, fechaFin) 
    VALUES(20,14,8,'quis turpis sed ante','29/03/2023', '6/6/2023');

INSERT INTO PROYECTOS(idProyecto,idOrganizacion,numeroContrato,descripcion,fechainicio, fechaFin) 
    VALUES(21,18,17,'leo rhoncus sed','12/11/2022', '29/05/2023');

INSERT INTO PROYECTOS(idProyecto,idOrganizacion,numeroContrato,descripcion,fechainicio, fechaFin) 
    VALUES(22,24,1,'ac neque duis bibendum morbi','9/4/2023', '31/07/2023');

INSERT INTO PROYECTOS(idProyecto,idOrganizacion,numeroContrato,descripcion,fechainicio, fechaFin) 
    VALUES(23,2,17,'luctus cum sociis','28/11/2022', '8/7/2023');

INSERT INTO PROYECTOS(idProyecto,idOrganizacion,numeroContrato,descripcion,fechainicio) 
    VALUES(24,14,15,'ultrices posuere cubilia curae nulla','14/04/2015');

INSERT INTO PROYECTOS(idProyecto,idOrganizacion,numeroContrato,descripcion,fechainicio) 
    VALUES(25,23,1,'Lavar un arbol','14/04/2015');

--EMPLEADOS
INSERT INTO EMPLEADOS(idEmpleado, nombre, nombreOficina, idCarpeta, correo, telefono)
    VALUES(1, 'Juan Contreras', 'Oficina de educacion', 26, 'jdaibsfiasb@gmail.com', 3023289465);

INSERT INTO EMPLEADOS(idEmpleado, nombre, nombreOficina, idCarpeta, correo, telefono)
    VALUES(2, 'Lorelei Ludmann', 'Oficina de educacion', 27, 'ldurbin7@china.com.cn', 8255271229);

INSERT INTO EMPLEADOS(idEmpleado, nombre, nombreOficina, idCarpeta, correo, telefono)
    VALUES(3, 'Marcelia Meletti', 'Oficina de educacion', 28, 'daitchisona@php.net', 1702427132);

INSERT INTO EMPLEADOS(idEmpleado, nombre, nombreOficina, idCarpeta, correo, telefono)
    VALUES(4, 'Maurine Stripp', 'Oficina de educacion', 29, 'lwillbourned@yelp.com', 2432553618);

INSERT INTO EMPLEADOS(idEmpleado, nombre, nombreOficina, idCarpeta, correo, telefono)
    VALUES(5, 'Loralee Durbin', 'Oficina de educacion', 30, 'tcritchellg@ycombinator.com', 2492830359);

INSERT INTO EMPLEADOS(idEmpleado, nombre, nombreOficina, idCarpeta, correo, telefono)
    VALUES(6, 'Waylan Pengelley', 'Oficina de hacienda', 31, 'ghairsj@1688.com', 5912456493);

INSERT INTO EMPLEADOS(idEmpleado, nombre, nombreOficina, idCarpeta, correo, telefono)
    VALUES(7, 'Tasia Kobiera', 'Oficina de hacienda', 32, 'mdoxeym@spotify.com', 4908024260);

INSERT INTO EMPLEADOS(idEmpleado, nombre, nombreOficina, idCarpeta, correo, telefono)
    VALUES(8, 'Joletta Spohr', 'Oficina de hacienda', 33, 'bslimmn@theatlantic.com', 9866136363);

INSERT INTO EMPLEADOS(idEmpleado, nombre, nombreOficina, idCarpeta, correo, telefono)
    VALUES(9, 'Brittani Atmore', 'Oficina de hacienda', 34, 'ahyattp@issuu.com', 2287892483);

INSERT INTO EMPLEADOS(idEmpleado, nombre, nombreOficina, idCarpeta, correo, telefono)
    VALUES(10, 'Perry Osler', 'Oficina de hacienda', 35, 'iwoodyearr@techcrunch.com', 3969040581);

INSERT INTO EMPLEADOS(idEmpleado, nombre, nombreOficina, idCarpeta, correo, telefono)
    VALUES(11, 'Port Fidoe', 'Oficina de desarrollo economico', 36, 'poslert@over-blog.com', 7773734430);

INSERT INTO EMPLEADOS(idEmpleado, nombre, nombreOficina, idCarpeta, correo, telefono)
    VALUES(12, 'Sonnie Dudman', 'Oficina de desarrollo economico', 37, 'vbourgetw@wunderground.com', 9924961999);

INSERT INTO EMPLEADOS(idEmpleado, nombre, nombreOficina, idCarpeta, correo, telefono)
    VALUES(13, 'Brien Fedorchenko', 'Oficina de desarrollo economico', 38, 'ljuggingy@woothemes.com', 3209950492);

INSERT INTO EMPLEADOS(idEmpleado, nombre, nombreOficina, idCarpeta, correo, telefono)
    VALUES(14, 'Papageno Chalcot', 'Oficina de desarrollo economico', 39, 'pchalcotz@w3.org', 2108732731);

INSERT INTO EMPLEADOS(idEmpleado, nombre, nombreOficina, idCarpeta, correo, telefono)
    VALUES(15, 'Cloris Dennison', 'Oficina de desarrollo economico', 40, 'ctasch11@state.gov', 9236826060);

INSERT INTO EMPLEADOS(idEmpleado, nombre, nombreOficina, idCarpeta, correo, telefono)
    VALUES(16, 'Kirbee Thorouggood', 'Oficina de gobierno', 41, 'mroughley13@plala.or.jp', 8788607966);

INSERT INTO EMPLEADOS(idEmpleado, nombre, nombreOficina, idCarpeta, correo, telefono)
    VALUES(17, 'Moises Staveley', 'Oficina de gobierno', 42, 'kaicken1k@nps.gov', 2549061436);

INSERT INTO EMPLEADOS(idEmpleado, nombre, nombreOficina, idCarpeta, correo, telefono)
    VALUES(18, 'Anselm Jellicorse', 'Oficina de gobierno', 43, 'hdenzey1n@timesonline.co.uk', 5682912567);

INSERT INTO EMPLEADOS(idEmpleado, nombre, nombreOficina, idCarpeta, correo, telefono)
    VALUES(19, 'Klara Aicken', 'Oficina de gobierno', 44, 'qquantrill1p@biglobe.ne.jp', 4544625123);

INSERT INTO EMPLEADOS(idEmpleado, nombre, nombreOficina, idCarpeta, correo, telefono)
    VALUES(20, 'Loretta Caplen', 'Oficina de gobierno', 45, 'gcelez1s@pinterest.com', 7868336871);

INSERT INTO EMPLEADOS(idEmpleado, nombre, nombreOficina, idCarpeta, correo, telefono)
    VALUES(21, 'Hilliary Denzey', 'Oficina general', 46, 'wobradane1u@noaa.gov', 2818754764);

INSERT INTO EMPLEADOS(idEmpleado, nombre, nombreOficina, idCarpeta, correo, telefono)
    VALUES(22, 'Quill Quantrill', 'Oficina general', 47, 'cklimp1v@ucla.edu', 5245487571);

INSERT INTO EMPLEADOS(idEmpleado, nombre, nombreOficina, idCarpeta, correo, telefono)
    VALUES(23, 'Evangelina Elcoate', 'Oficina general', 48, 'ngiamuzzo1x@mysql.com', 8135953192);

INSERT INTO EMPLEADOS(idEmpleado, nombre, nombreOficina, idCarpeta, correo, telefono)
    VALUES(24, 'Drusy Oluwatoyin', 'Oficina general', 49, 'lfleisch20@e-recht24.de', 7771207217);

INSERT INTO EMPLEADOS(idEmpleado, nombre, nombreOficina, idCarpeta, correo, telefono)
    VALUES(25, 'Albertine Bover', 'Oficina general', 50, 'jlslot24@facebook.com', 9893875860);

--HISTORIASLABORALES
INSERT INTO HISTORIASLABORALES (numeroHistoria, idEmpleado, idCarpeta)
    VALUES (1, 25, 26);

INSERT INTO HISTORIASLABORALES (numeroHistoria, idEmpleado, idCarpeta)
    VALUES (2, 24, 27);

INSERT INTO HISTORIASLABORALES (numeroHistoria, idEmpleado, idCarpeta)
    VALUES (3, 23, 28);

INSERT INTO HISTORIASLABORALES (numeroHistoria, idEmpleado, idCarpeta)
    VALUES (4, 22, 29);

INSERT INTO HISTORIASLABORALES (numeroHistoria, idEmpleado, idCarpeta)
    VALUES (5, 21, 30);

INSERT INTO HISTORIASLABORALES (numeroHistoria, idEmpleado, idCarpeta)
    VALUES (6, 20, 31);

INSERT INTO HISTORIASLABORALES (numeroHistoria, idEmpleado, idCarpeta)
    VALUES (7, 19, 32);

INSERT INTO HISTORIASLABORALES (numeroHistoria, idEmpleado, idCarpeta)
    VALUES (8, 18, 33);

INSERT INTO HISTORIASLABORALES (numeroHistoria, idEmpleado, idCarpeta)
    VALUES (9, 17, 34);

INSERT INTO HISTORIASLABORALES (numeroHistoria, idEmpleado, idCarpeta)
    VALUES (10, 16, 35);

INSERT INTO HISTORIASLABORALES (numeroHistoria, idEmpleado, idCarpeta)
    VALUES (11, 15, 36);

INSERT INTO HISTORIASLABORALES (numeroHistoria, idEmpleado, idCarpeta)
    VALUES (12, 14, 37);

INSERT INTO HISTORIASLABORALES (numeroHistoria, idEmpleado, idCarpeta)
    VALUES (13, 13, 38);

INSERT INTO HISTORIASLABORALES (numeroHistoria, idEmpleado, idCarpeta)
    VALUES (14, 12, 39);

INSERT INTO HISTORIASLABORALES (numeroHistoria, idEmpleado, idCarpeta)
    VALUES (15, 11, 40);

INSERT INTO HISTORIASLABORALES (numeroHistoria, idEmpleado, idCarpeta)
    VALUES (16, 10, 41);

INSERT INTO HISTORIASLABORALES (numeroHistoria, idEmpleado, idCarpeta)
    VALUES (17, 9, 42);

INSERT INTO HISTORIASLABORALES (numeroHistoria, idEmpleado, idCarpeta)
    VALUES (18, 8, 43);

INSERT INTO HISTORIASLABORALES (numeroHistoria, idEmpleado, idCarpeta)
    VALUES (19, 7, 44);

INSERT INTO HISTORIASLABORALES (numeroHistoria, idEmpleado, idCarpeta)
    VALUES (20, 6, 45);

INSERT INTO HISTORIASLABORALES (numeroHistoria, idEmpleado, idCarpeta)
    VALUES (21, 5, 46);

INSERT INTO HISTORIASLABORALES (numeroHistoria, idEmpleado, idCarpeta)
    VALUES (22, 4, 47);

INSERT INTO HISTORIASLABORALES (numeroHistoria, idEmpleado, idCarpeta)
    VALUES (23, 3, 48);

INSERT INTO HISTORIASLABORALES (numeroHistoria, idEmpleado, idCarpeta)
    VALUES (24, 2, 49);

INSERT INTO HISTORIASLABORALES (numeroHistoria, idEmpleado, idCarpeta)
    VALUES (25, 1, 50);

--DOCUMENTOSADJUNTOS
INSERT INTO DOCUMENTOSADJUNTOS(numeroDocumento, numeroHistoria, idEmpleado, nombreDocumento)
    VALUES(1, 25, 1, ' Hoja de vida');

INSERT INTO DOCUMENTOSADJUNTOS(numeroDocumento, numeroHistoria, idEmpleado, nombreDocumento)
    VALUES(2, 24, 2, 'Soportes académicos de títulos obtenidos');

INSERT INTO DOCUMENTOSADJUNTOS(numeroDocumento, numeroHistoria, idEmpleado, nombreDocumento)
    VALUES(3, 23, 3, 'Certificaciones laborales');

INSERT INTO DOCUMENTOSADJUNTOS(numeroDocumento, numeroHistoria, idEmpleado, nombreDocumento)
    VALUES(4, 22, 4, 'Fotocopia de la tarjeta profesional');

INSERT INTO DOCUMENTOSADJUNTOS(numeroDocumento, numeroHistoria, idEmpleado, nombreDocumento)
    VALUES(5, 21, 5, 'Fotocopia de carné de vacunación');

INSERT INTO DOCUMENTOSADJUNTOS(numeroDocumento, numeroHistoria, idEmpleado, nombreDocumento)
    VALUES(6, 20, 6, 'Fotocopia de cédula de ciudadanía');

INSERT INTO DOCUMENTOSADJUNTOS(numeroDocumento, numeroHistoria, idEmpleado, nombreDocumento)
    VALUES(7, 19, 7, ' Antecedentes judiciales');

INSERT INTO DOCUMENTOSADJUNTOS(numeroDocumento, numeroHistoria, idEmpleado, nombreDocumento)
    VALUES(8, 18, 8, 'Certificado de afiliación a EPS');

INSERT INTO DOCUMENTOSADJUNTOS(numeroDocumento, numeroHistoria, idEmpleado, nombreDocumento)
    VALUES(9, 17, 9, 'Certificado de afiliación a EPS');

INSERT INTO DOCUMENTOSADJUNTOS(numeroDocumento, numeroHistoria, idEmpleado, nombreDocumento)
    VALUES(10, 16, 10, ' Certificado de afiliacion al fondo de cesantias');

INSERT INTO DOCUMENTOSADJUNTOS(numeroDocumento, numeroHistoria, idEmpleado, nombreDocumento)
    VALUES(11, 15, 11, ' Formato de vinculación de personal.');

INSERT INTO DOCUMENTOSADJUNTOS(numeroDocumento, numeroHistoria, idEmpleado, nombreDocumento)
    VALUES(12, 14, 12, 'Verificación experiencia personal.');

INSERT INTO DOCUMENTOSADJUNTOS(numeroDocumento, numeroHistoria, idEmpleado, nombreDocumento)
    VALUES(13, 13, 13, 'Verificación experiencia personal.');

INSERT INTO DOCUMENTOSADJUNTOS(numeroDocumento, numeroHistoria, idEmpleado, nombreDocumento)
    VALUES(14, 12, 14, 'Declaración juramentada');

INSERT INTO DOCUMENTOSADJUNTOS(numeroDocumento, numeroHistoria, idEmpleado, nombreDocumento)
    VALUES(15, 11, 15, 'Declaración juramentada');

INSERT INTO DOCUMENTOSADJUNTOS(numeroDocumento, numeroHistoria, idEmpleado, nombreDocumento)
    VALUES(16, 10, 16, 'Fotografía 3x4 tipo documento,');

INSERT INTO DOCUMENTOSADJUNTOS(numeroDocumento, numeroHistoria, idEmpleado, nombreDocumento)
    VALUES(17, 9, 17, ' Certificaciones laborales');

INSERT INTO DOCUMENTOSADJUNTOS(numeroDocumento, numeroHistoria, idEmpleado, nombreDocumento)
    VALUES(18, 8, 18, 'Copia del registro civil de nacimiento');

INSERT INTO DOCUMENTOSADJUNTOS(numeroDocumento, numeroHistoria, idEmpleado, nombreDocumento)
    VALUES(19, 7, 19, 'Soportes académicos de títulos obtenidos');

INSERT INTO DOCUMENTOSADJUNTOS(numeroDocumento, numeroHistoria, idEmpleado, nombreDocumento)
    VALUES(20, 6, 20, ' Hoja de vida actualizada');

INSERT INTO DOCUMENTOSADJUNTOS(numeroDocumento, numeroHistoria, idEmpleado, nombreDocumento)
    VALUES(21, 5, 21, 'Certificado de afiliación a EPS');

INSERT INTO DOCUMENTOSADJUNTOS(numeroDocumento, numeroHistoria, idEmpleado, nombreDocumento)
    VALUES(22, 4, 22, 'Certificado de afiliación al fondo de pensiones');

INSERT INTO DOCUMENTOSADJUNTOS(numeroDocumento, numeroHistoria, idEmpleado, nombreDocumento)
    VALUES(23, 3, 23, 'Formato de vinculación de personal.');

INSERT INTO DOCUMENTOSADJUNTOS(numeroDocumento, numeroHistoria, idEmpleado, nombreDocumento)
    VALUES(24, 2, 24, 'Verificación experiencia personal.');

INSERT INTO DOCUMENTOSADJUNTOS(numeroDocumento, numeroHistoria, idEmpleado, nombreDocumento)
    VALUES(25, 1, 25, 'Antecedentes');


--PoblarNoOk
--OFICINAS
INSERT INTO OFICINAS (nombre, encargado, presupuesto)
    VALUES ('Oficina de educacion', 'Juan', 32000000.00);  --Valor no valido para encargado, se pone su nombre donde deberia ir su ID

INSERT INTO OFICINAS (encargado, presupuesto)
    VALUES (123, 32000000.00);   --Datos icompletos, se inserta una oficina sin nombre

--Proveedores
INSERT INTO PROVEEDORES(nombre, id, direccion, correo) 
    VALUES('ELECTRONICOS', 1, 123, 'electronicos@gamil.com'); --Datos no validos, direccion no cumple con el tipo de dato

--BienesOfrecidos
INSERT INTO BIENESOFRECIDOS(idBien, idServicio, idProveedor) 
    VALUES('rojo',1,123);                                     --Datos no validos, idBien no cumple con el tipo de dato correspondiente

INSERT INTO BIENESOFRECIDOS(idProducto, idServicio, idProveedor)
    VALUES(1,2,123)                                           --Falta PK

--Productos

INSERT INTO PRODUCTOS(idProducto, precio, nombre)
    VALUES(14, 10000, 'Papel'); --Datos Insuficientes

INSERT INTO PRODUCTOS(idProducto, precio, nombre, unidadesActuales)
    VALUES('Carro', 'Rojo', 123, 'Una');  --Tipos de datos incorrectos

--Compras

INSERT INTO COMPRAS(numero, fecha, nombreoficina)
    VALUES(1,'Ayer', 'Oficina de educacion');  --Fecha sin formato correcto

INSERT INTO COMPRAS(numero, fecha, nombreoficina)
    VALUES('Dos', '12/12/2022', 1);   --Nombre oficina incorrecto, numero compra incorrecto

--Carpetas

INSERT INTO CARPETAS(idCarpeta, numeroCarpetas, descripcion, estado)
    VALUES(1, 10, 'DOCUMENTOS', 'Vacia');  --Datos incorrectos

--DocumentosAdjuntos

INSERT INTO DOCUMENTOSADJUNTOS(numerodocumento, numeroHistoria, idEmpleado, numerodocumento)
    VALUES(1,1,'Oficina de educacion', 1004);   --Datos incorrectos

--Contratos

INSERT INTO CONTRATOS(numeroContrato, idcarpeta, objeto, valor)
    VALUES(1111,1111,111,'Cero');  --Datos incorrectos

INSERT INTO CONTRATOS(idcarpeta, objeto, valor)
    VALUES(12, 'Carretera', 12000000);   --Falta PK

--Organizaciones

INSERT INTO ORGANIZACIONES(idOrganizacion, nit, direccion)
    VALUES('14',1452, 'Bogota');    --Falta nombre, ID invalido

--Servicios

INSERT INTO SERVICIOS(idServicio, precio, nombre, fechapago, estado)
    VALUES(123, 500000, 'Mantenimiento carretera', 1, 'P');  --Fecha pago invalida

--LineasCompras

 INSERT INTO LINEASCOMPRAS(idbien, numerocompra, cantidad)
    VALUES(14, 'oficina de educacion', 10);  --Numero compra invalida

--HistoriasLaborales

INSERT INTO HISTORIASLABORALES(numerohistoria, idEmpleado, idcarpeta)
    VALUES(12,'Mia k', 14); --Id empleado incorrecto

--Empleados

INSERT INTO EMPLEADOS(idEmpleado, nombre, nombreoficina, idcarpeta, correo, telefono)
    VALUES(14, 14, 'Oficina de educacion', 5, 'juan@alcaldia.com', 3133133333); --Nombre invalido

--Proyectos

INSERT INTO PROYECTOS(idproyecto, idOrganizacion, numerocontrato, descripcion, fechainicio, fechafin)
    VALUES(1, 2, 3, 'pintar', 'hoy', 'un mes'); --fechas invalidas

----------------------------------------------XPoblar-------------------------------------------
--PROYECTOS
DELETE FROM PROYECTOS
    WHERE idproyecto > 0
/
--TELEFONOS
DELETE FROM TELEFONOS
    WHERE idEntidad > 0
/
--ORGANIZACIONES
DELETE FROM ORGANIZACIONES
    WHERE idOrganizacion > 0
/
--CONTRATOS
DELETE FROM CONTRATOS
    WHERE numeroContrato > 0
/
--DOCUMENTOSADJUNTOS
DELETE FROM DOCUMENTOSADJUNTOS
    WHERE numeroDocumento > 0
/
--HISTORIASLABORALES
DELETE FROM HISTORIASLABORALES
    WHERE numeroHistoria > 0
/
--EMPLEADOS
DELETE FROM EMPLEADOS
    WHERE idEmpleado > 0
/
--CARPETAS
DELETE FROM CARPETAS
    WHERE idCarpeta > 0
/
--COMPRAS
DELETE FROM COMPRAS
    WHERE numero > 0
/
--OFICINAS
DELETE FROM OFICINAS
    WHERE nombre LIKE 'Oficina%'
/
--PROVEEDORES
DELETE FROM PROVEEDORES
    WHERE id > 0
/
--PRODUCTOS
DELETE FROM PRODUCTOS
    WHERE idproducto > 0
/
--SERVICIOS
DELETE FROM SERVICIOS
    WHERE idServicio > 0
/



--Consultas
SELECT ENCARGADO, PRESUPUESTO FROM OFICINAS; --PREGUNTAR SI SE IMPLEMENTA CON PAQUETES
SELECT * FROM ORGANIZACIONES JOIN PROYECTOS ON ORGANIZACIONES.IDORGANIZACION=PROYECTOS.IDORGANIZACION;

--Consultar a quien corresponde una carpeta y su contenido
SELECT EMPLEADOS.nombre, DOCUMENTOSADJUNTOS.nombreDocumento FROM CARPETAS
JOIN HISTORIASLABORALES ON (CARPETAs.idCarpeta)
JOIN EMPLEADOS ON (HISTORIASLABORALES.idEmpleado = EMPLEADOS.idEmpleado)


SELECT ORGANIZACIONES.nombre, PROYECTOS.descripcion FROM CARPETAS
JOIN CONTRATOS ON (CARPETAS.idCarpeta = CONTRATOS.idCarpeta)
JOIN PROYECTOS ON (CONTRATOS.numeroContrato = PROYECTOS.numeroContrato)
JOIN ORGANIZACIONES ON (PROYECTOS.idOrganizacion = ORGANIZACIONES.idOrganizacion)