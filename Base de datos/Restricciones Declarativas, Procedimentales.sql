
--Restricciones de tupla

ALTER TABLE BIENESOFRECIDOS ADD CONSTRAINT CH_BIENESOFRECIDOS
    CHECK((IDSERVICIO IS NULL AND IDPRODUCTO IS NOT NULL) OR (IDSERVICIO IS NOT NULL AND IDPRODUCTO IS NULL));

ALTER TABLE PROYECTOS ADD CONSTRAINT CH_PROYECTOS
    CHECK(fechaInicio<fechaFin);

ALTER TABLE SERVICIOS ADD CONSTRAINT CH_SERVICIOS_TUPLA
    CHECK((FECHAPAGO IS NOT NULL AND ESTADO='P') OR (FECHA PAGO IS NULL AND ESTADO='N'));


--tuplas Ok

INSERT INTO BIENESOFRECIDOS(idbien, idProducto, idProveedor) 
    VALUES (3, 14 ,8);

INSERT INTO BIENESOFRECIDOS(idbien, idServicio, idProveedor) 
    VALUES (21, 1, 9);

INSERT INTO PROYECTOS(idProyecto,idOrganizacion,numeroContrato,descripcion,fechainicio, fechaFin) 
    VALUES(16,6,18,'neque duis bibendum morbi','16/01/2023', '11/7/2023');

INSERT INTO PROYECTOS(idProyecto,idOrganizacion,numeroContrato,descripcion,fechainicio, fechaFin) 
    VALUES(17,3,4,'dis parturient montes','3/8/2022', '24/08/2023');

INSERT INTO SERVICIOS(idServicio, precio, nombre, fechaPago, estado) 
    VALUES(2, 1.75, 'agua', '01/3/2022', 'P');

INSERT INTO SERVICIOS(idServicio, precio, nombre, estado) 
    VALUES(3, 8.79, 'gas', 'N');

--tuplas noOk

INSERT INTO BIENESOFRECIDOS(idbien, idProducto, idServicio, idProveedor) 
    VALUES (3, 14 ,8 ,8);

INSERT INTO BIENESOFRECIDOS(idBien, idProveedor) 
    VALUES (3,8);

INSERT INTO PROYECTOS(idProyecto,idOrganizacion,numeroContrato,descripcion,fechainicio, fechaFin) 
    VALUES(17,3,4,'dis parturient montes','3/8/2024', '24/08/2023'); 

INSERT INTO SERVICIOS(idServicio, precio, nombre, fechaPago, estado) 
    VALUES(2, 1.75, 'agua', '01/3/2022', 'N');

INSERT INTO SERVICIOS(idServicio, precio, nombre, fechaPago, estado) 
    VALUES(3, 8.79, 'gas', '30/12/2022', 'N');

--Registrar compra
CREATE OR REPLACE TRIGGER TG_COMPRAS_AD
    BEFORE INSERT ON COMPRAS
    FOR EACH ROW
        DECLARE CANTIDAD INT;
        BEGIN 
            SELECT COUNT(*) INTO CANTIDAD FROM COMPRAS;
            IF CANTIDAD IS NULL THEN
                CANTIDAD:=0;
            END IF;
            :NEW.NUMERO:=CANTIDAD+1;
            :NEW.FECHA:=SYSDATE;
        END;
/
--Coreccion trigger
CREATE OR REPLACE TRIGGER TG_LINEASCOMPRAS_AD    --preguntar nulidades compuestas.
    BEFORE INSERT ON LINEASCOMPRAS
    FOR EACH ROW
        DECLARE 
            OFICINA VARCHAR(20);
            PR DECIMAL(13,2);
            TOTAL DECIMAL(13,2);
            UNIDADES INT;
            SERVICIOBIEN INT;
            BN INT;
        BEGIN
        SELECT IDSERVICIO INTO SERVICIOBIEN FROM BIENESOFRECIDOS WHERE BIENESOFRECIDOS.IDBIEN=:NEW.IDBIEN;
        IF SERVICIOBIEN IS NULL THEN
            SELECT NOMBREOFICINA INTO OFICINA FROM COMPRAS WHERE :NEW.NUMEROCOMPRA=COMPRAS.NUMERO;
            SELECT PRESUPUESTO INTO PR FROM OFICINAS WHERE NOMBRE=OFICINA;
            SELECT IDPRODUCTO INTO BN FROM BIENESOFRECIDOS WHERE :NEW.IDBIEN=BIENESOFRECIDOS.IDBIEN;  
            SELECT PRECIO INTO TOTAL FROM PRODUCTOS WHERE PRODUCTOS.IDPRODUCTO=BN;
            SELECT UNIDADESACTUALES INTO UNIDADES FROM PRODUCTOS WHERE PRODUCTOS.IDPRODUCTO=BN;
            UPDATE OFICINAS SET PRESUPUESTO=PR-TOTAL*:NEW.CANTIDAD WHERE NOMBRE=OFICINA;
            UPDATE PRODUCTOS SET UNIDADESACTUALES=UNIDADES+:NEW.CANTIDAD WHERE IDPRODUCTO=BN;
        END IF;
        END;
/
CREATE OR REPLACE TRIGGER TG_COMPRAS_MO  
    BEFORE UPDATE ON COMPRAS
        FOR EACH ROW
            BEGIN
                :NEW.NUMERO:=:OLD.NUMERO;
                :NEW.FECHA:=:OLD.FECHA;
                :NEW.NOMBREOFICINA:=:OLD.NOMBREOFICINA;
            END;
/
CREATE OR REPLACE TRIGGER TG_LINEASCOMPRAS_MO  --no se puede probar hasta corregir
    BEFORE UPDATE ON LINEASCOMPRAS
        FOR EACH ROW
            BEGIN
                RAISE_APPLICATION_ERROR(-20001,'No se puede modificar');
            END;
/
CREATE OR REPLACE TRIGGER TG_COMRPRAS_EL
    BEFORE DELETE ON COMPRAS
        FOR EACH ROW
        DECLARE 
            LINEAS INT;
        BEGIN
            SELECT COUNT(*) INTO LINEAS FROM LINEASCOMPRAS WHERE NUMEROCOMPRA=:OLD.NUMERO;
            IF LINEAS IS NULL THEN 
            LINEAS:=0;
            END IF;
            IF LINEAS > 0 THEN
                RAISE_APPLICATION_ERROR(-20001,'No se puede eliminar la compra');
            END IF;
        END;
/

--Mantener bien

CREATE OR REPLACE TRIGGER TG_PROVEEDORES_AD
    BEFORE INSERT ON PROVEEDORES
        FOR EACH ROW
        DECLARE NID INT;
        BEGIN
            SELECT COUNT(*) INTO NID FROM PROVEEDORES;
            IF NID IS NULL THEN
                NID:=0;
            END IF;
            :NEW.ID:=NID+1;
        END;
/
CREATE OR REPLACE TRIGGER TG_PROVEEDORES_MO
    BEFORE UPDATE ON PROVEEDORES
    FOR EACH ROW
    BEGIN
        :NEW.NOMBRE:=:OLD.NOMBRE;
        :NEW.ID:=:OLD.ID;
    END;
/
CREATE OR REPLACE TRIGGER TG_PROVEEDORES_EL
    BEFORE DELETE ON PROVEEDORES
    FOR EACH ROW
    DECLARE 
        CLC INT; --CantidadLineaCompra de un proveedor
    BEGIN
        SELECT COUNT(*) INTO CLC FROM LINEASCOMPRAS 
            JOIN BIENESOFRECIDOS ON LINEASCOMPRAS.idBien = BIENESOFRECIDOS.idBien 
            WHERE BIENESOFRECIDOS.idProveedor=:OLD.id;

        IF CLC IS NULL THEN 
            CLC:=0;
        END IF;
        IF CLC > 0 THEN
            RAISE_APPLICATION_ERROR(-20001,'No se puede eliminar');
        END IF;
    END;
/
--Mantener oficina
CREATE OR REPLACE TRIGGER TG_OFICINAS_MO
    BEFORE UPDATE ON OFICINAS
    FOR EACH ROW
    BEGIN
        :NEW.NOMBRE:=:OLD.NOMBRE;
    END;
/
CREATE OR REPLACE TRIGGER TG_OFICINAS_EL
    BEFORE DELETE ON OFICINAS
    FOR EACH ROW
    BEGIN
        RAISE_APPLICATION_ERROR(-20001,'No se pueden eliminar oficinas');
    END;
/



--automatizar idCarpetas e inicializar el numero de carpetas en 1
create or replace TRIGGER TG_CARPETAS_AD
BEFORE INSERT ON CARPETAS
    FOR EACH ROW
    DECLARE 
    NUMERO INT;
    BEGIN
    SELECT MAX(idCarpeta) INTO NUMERO FROM CARPETAS;
    IF NUMERO IS NULL 
    THEN NUMERO := 0;
    END IF;
    :NEW.idCarpeta := (NUMERO)+1;
    :NEW.numeroCarpetas := 1;
END;
/
--Permite actualizar unicamente el numero de carpetas y la descripcion 
CREATE OR REPLACE TRIGGER TG_CARPETAS_MO
BEFORE UPDATE ON CARPETAS
    FOR EACH ROW
    BEGIN
    :NEW.idCarpeta := :OLD.idCarpeta;
    :NEW.numeroCarpetas := :NEW.numeroCarpetas;
    :NEW.descripcion := :NEW.descripcion;
    :NEW.estado := :NEW.estado;
END;
/
--Permite eliminar unicamente las carpetas que no tengan ni historias laborales ni contratos asociados
CREATE OR REPLACE TRIGGER TG_CARPETAS_EL
BEFORE DELETE ON CARPETAS
    FOR EACH ROW
    DECLARE
    historiaLaboral INT;
    contrato INT;
    BEGIN
        SELECT COUNT(*) INTO historiaLaboral FROM HISTORIASLABORALES
            WHERE idCarpeta = :OLD.idCarpeta;
        
        SELECT COUNT(*) INTO contrato FROM CONTRATOS
            WHERE idCarpeta = :OLD.idCarpeta;
        
        IF historiaLaboral IS NULL THEN 
            historiaLaboral:=0;
        END IF;
        IF contrato IS NULL THEN 
            contrato:=0;
        END IF;
        
        IF historiaLaboral = 0 AND contrato > 0 THEN
            RAISE_APPLICATION_ERROR(-20001,'La carpeta tinene un contrato asociado');
        ELSIF historiaLaboral > 0 AND contrato = 0 THEN
            RAISE_APPLICATION_ERROR(-20001,'La carpeta tinene una historia laboral asociada');
        END IF;
END;
/

--Triggers y accion de referencia de ORGANIZACIONES
--Automatiza el idOrganizacion
create or replace TRIGGER TG_ORGANIZACIONES_AD
BEFORE INSERT ON ORGANIZACIONES
    FOR EACH ROW
    DECLARE 
    NUMERO INT;
    BEGIN
    SELECT MAX(idOrganizacion) INTO NUMERO FROM ORGANIZACIONES;
    IF numero IS NULL 
    THEN numero := 0;
    END IF;
    :NEW.idOrganizacion := (NUMERO)+1;
END;
/
--Permite actualizar unicamente el nombre y la direccion de una organizacion
CREATE OR REPLACE TRIGGER TG_ORGANIZACIONES_MO
BEFORE UPDATE ON ORGANIZACIONES
    FOR EACH ROW
    BEGIN
    :NEW.idOrganizacion := :OLD.idOrganizacion;
    :NEW.nombre := :NEW.nombre;
    :NEW.nit := :OLD.nit;
    :NEW.direccion := :NEW.direccion;
END;
/

--Permite eliminar unicamente organizaciones sin proyectos asociados
CREATE OR REPLACE TRIGGER TG_ORGANIZACIONES_EL
BEFORE DELETE ON ORGANIZACIONES
    FOR EACH ROW
    DECLARE
    numeroProyecto INT;
    BEGIN
    SELECT COUNT(*) INTO numeroProyecto FROM PROYECTOS
    WHERE idOrganizacion = :OLD.idOrganizacion;
    IF numeroProyecto > 0 THEN    
        RAISE_APPLICATION_ERROR(-20001,'La organizacion tiene proyectos asociados');
    END IF;
END;
/

--Triggers de PROYECTOS
--Automatiza el idProyecto e inicializa la fecha de inicio y la fecha de fin (en Null)
create or replace TRIGGER TG_PROYECTOS_AD
BEFORE INSERT ON PROYECTOS
    FOR EACH ROW
    DECLARE 
    NUMERO INT;
    BEGIN
    SELECT MAX(idProyecto) INTO NUMERO FROM PROYECTOS;
    IF NUMERO IS NULL 
    THEN NUMERO := 0;
    END IF;
    :NEW.idProyecto := (NUMERO)+1;
    :NEW.fechaInicio := SYSDATE;
    :NEW.fechaFin := NULL;
END;
/
--Permite actualizar unicamente la descripcion y la fecha fin de un proyecto
CREATE OR REPLACE TRIGGER TG_PROYECTOS_MO
BEFORE UPDATE ON PROYECTOS
    FOR EACH ROW
    BEGIN
    IF :NEW.fechaFin > :OLD.fechaInicio THEN
        :NEW.idProyecto := :OLD.idProyecto;
        :NEW.idOrganizacion := :OLD.idOrganizacion;
        :NEW.numeroContrato := :OLD.numeroContrato;
        :NEW.fechaInicio := :OLD.fechaInicio;
    ELSE 
        RAISE_APPLICATION_ERROR(-20001,'La fecha de fin debe ser posterior a la fecha de inicio');
    END IF;
END;
/
--Permite eliminar unicamente proyectos que ya se hayan completado
create or replace TRIGGER TG_PROYECTOS_EL
BEFORE DELETE ON PROYECTOS
    FOR EACH ROW
    DECLARE
    dia DATE;
    BEGIN
    SELECT TO_CHAR(SYSDATE, 'DD/MM/YYYY') INTO dia FROM dual;

    IF dia < :OLD.fechaFin THEN
        RAISE_APPLICATION_ERROR(-20001,'el proyecto aun no ha finalizado');
    END IF;
END;
/
---------------------------------------Accines Referenciales---------------------------------------
--Accion de referencia que elimina el numero de una organizacion cuando esta es eliminada
ALTER TABLE TELEFONOS DROP CONSTRAINT FK_TELEFONOS_ORGANIZACIONES;
ALTER TABLE TELEFONOS ADD CONSTRAINT FK_TELEFONOS_ORGANIZACIONES
    FOREIGN KEY(idEntidad) REFERENCES ORGANIZACIONES(idOrganizacion) ON DELETE CASCADE;

--Accion referencial que vuelve nulos los provedores si se elimina
ALTER TABLE BIENESOFRECIDOS DROP CONSTRAINT FK_BIENES_OFRECIDOS_PROVEEDORES;

ALTER TABLE BIENESOFRECIDOS ADD CONSTRAINT FK_BIENES_OFRECIDOS_PROVEEDORES 
    FOREIGN KEY (idProveedor) REFERENCES PROVEEDORES(id) ON DELETE SET NULL;

-----------------------------------------DisparadoresOk-----------------------------------------
--TG_OFICINAS_MO
select * from oficinas;

UPDATE OFICINAS SET nombre= 'oficina xd', presupuesto = 54451, encargado=32
WHERE nombre = 'Oficina de educacion'

select * from oficinas;

--TG_OFICINAS_EL
DELETE FROM OFICINAS 
WHERE nombre = 'Oficina de educacion'

--TG_PROVEEDORES_AD
select * from PROVEEDORES;

INSERT INTO PROVEEDORES (nombre, id, direccion, correo)
    VALUES ('Carlos ', 5161, '45 #205-6','algobsgsfd.3lol@mail.com');

select * from PROVEEDORES;

--TG_PROVEEDORES_MO
select * from PROVEEDORES;

UPDATE PROVEEDORES SET nombre= 'Andrea', id = 54451, direccion = 'Delladonna Place #2-7', correo = 'fbruffafagemann1b@trellian.com'
WHERE id = 26

select * from PROVEEDORES;
--TG_PROVEEDORES_EL
INSERT INTO COMPRAS (numero, fecha, nombreOficina)
    VALUES (135, '3/05/2023', 'Oficina de educacion');
INSERT INTO BIENESOFRECIDOS (idBien, idProducto, idProveedor)
    VALUES (555, 10, 26);
INSERT INTO LINEASCOMPRAS (idBien, numeroCompra, cantidad)
    VALUES (555, 1, 3);
----------------------------
----------------------------
-----REVISAAAAAAAAAAAAAAAAAAAAR
----------------------------
----------------------------
DELETE FROM PROVEEDORES
    WHERE id = 26

--TG_LINEASCOMPRAS_MO
SELECT * FROM OFICINAS
WHERE nombre = 'Oficina de gobierno';

INSERT INTO COMPRAS (numero, fecha, nombreOficina)
    VALUES (27, '3/05/2023', 'Oficina de gobierno');
INSERT INTO BIENESOFRECIDOS (idBien, idProducto, idProveedor)
    VALUES (362, 20, 11);
INSERT INTO LINEASCOMPRAS (idBien, numeroCompra, cantidad)
    VALUES (362, 27, 10);

SELECT * FROM OFICINAS
WHERE nombre = 'Oficina de gobierno';
SELECT * FROM LINEASCOMPRAS

--TG_LINEASCOMPRAS_EL
UPDATE LINEASCOMPRAS SET idBien = 123, numerocompra = 51, cantidad = 15
WHERE idBien = 362;

--TG_COMPRAS_AD
INSERT INTO COMPRAS (numero, fecha, nombreOficina)
    VALUES (68464, '3/05/2023', 'Oficina de gobierno');

--TG_COMPRAS_MO
UPDATE COMPRAS SET numero = 123, fecha = '11/06/2019', nombreOficina = 'Oficina de desarrollo economico'
WHERE idBien = 15;

--TG_COMPRAS_EL
--para que arroje el error (la compra tiene una lineacompra asociada)
INSERT INTO BIENESOFRECIDOS (idBien, idProducto, idProveedor)
    VALUES (123, 15, 2);
INSERT INTO LINEASCOMPRAS (idBien, numeroCompra, cantidad)
    VALUES (123, 2, 1);

DELETE FROM COMPRAS
WHERE numero = 2;

--para que permita eliminar una compra (la compra NO tiene una lineacompra asociada)
DELETE FROM COMPRAS
WHERE numero = 3;

--TG_CARPETAS_AD
INSERT INTO CARPETAS(nombreOficina,numeroCarpetas,estado)
    VALUES('Oficina de educacion',4,'Faltan documentos ');

SELECT * FROM CARPETAS

--TG_CARPETAS_MO
UPDATE Carpetas SET idCarpeta=54,nombreoficina = 'Oficina de hacienda', numerocarpetas = 5, descripcion = '​​​​Es importante conocer cada parte de tu factura​​'
WHERE idcarpeta=1;

SELECT * FROM CARPETAS

--TG_CARPETAS_EL
--Carpeta con contrato asociado
DELETE FROM CARPETAS
WHERE idcarpeta = 1;
--Carpeta con historia laboral asociada
DELETE FROM CARPETAS
WHERE idcarpeta = 30;
--carpeta sin nada asociado
DELETE FROM CARPETAS
WHERE idcarpeta = 51;

--TG_ORGANIZACIONES_AD
INSERT INTO ORGANIZACIONES (idOrganizacion, nombre, nit, direccion)
    VALUES (1,'Oncobiologics, Inc.',48159156199, 'Corscot Center #426-32');
INSERT INTO ORGANIZACIONES ( nombre, nit, direccion)
    VALUES ('H&R Block, Inc.',376220564,'7#4-8 Clemons Pass');

SELECT * FROM ORGANIZACIONES

--TG_ORGANIZACIONES_MO
UPDATE ORGANIZACIONES SET idOrganizacion=5, nombre='UMH Properties, Inc.', nit=34238177100, direccion='#22-84 Meadow Vale Crossing'
WHERE idOrganizacion=2;

SELECT * FROM ORGANIZACIONES

--TG_ORGANIZACIONES_EL
INSERT INTO PROYECTOS(idProyecto,idOrganizacion,numeroContrato,descripcion,fechainicio) 
    VALUES(45,10,9,'Lavar un arbol','14/04/2015');

DELETE FROM ORGANIZACIONES
    WHERE idOrganizacion = 10


--TG_PROYECTOS_AD
INSERT INTO PROYECTOS(idProyecto,idOrganizacion,numeroContrato,descripcion,fechainicio) 
    VALUES(45,5,9,'Lavar un arbol','14/04/2015');

SELECT * FROM PROYECTOS

--TG_PROYECTOS_MO
--Fecha de fin anterior a la fecha de inicio
UPDATE PROYECTOS SET idProyecto = 541,idOrganizacion = 514,numeroContrato = 411,descripcion ='Construccion via vereda la Aurora' ,fechainicio = '14/03/2003'
WHERE idProyecto=2;

--Fecha de fin posterior a la fecha de inicio
UPDATE PROYECTOS SET idProyecto = 541,idOrganizacion = 514,numeroContrato = 411,descripcion ='Construccion via vereda la Aurora' ,fechainicio = '14/03/2033'
WHERE idProyecto=2;

--TG_PROYECTOS_EL
--Proyecto que aun no finaliza
UPDATE PROYECTOS SET idProyecto = 100,idOrganizacion = 15,numeroContrato = 10,descripcion ='Construccion via vereda la Aurora' ,fechaFin = '14/03/2026'
WHERE idProyecto=2;
DELETE FROM PROYECTOS
    WHERE idProyecto = 2;

--proyecto que ya finalizó
--Desactivar TG_PROYECTOS_AD para que permita ingrezar una fecha futura
INSERT INTO PROYECTOS(idProyecto,idOrganizacion,numeroContrato,descripcion,fechainicio) 
    VALUES(100,15,10,'recoleccion de basura en el rio Bogota','14/04/2015');
UPDATE PROYECTOS SET idProyecto = 100,idOrganizacion = 15,numeroContrato = 10,descripcion ='Construccion via vereda la Aurora' ,fechaFin = '14/03/2016'
WHERE idProyecto=100;
DELETE FROM PROYECTOS
WHERE idProyecto = 100;

SELECT * FROM PROYECTOS

-----------------------------------------AccionesOk-----------------------------------------
INSERT INTO TELEFONOS(telefono, idEntidad) 
    VALUES(3144587899,1);

SELECT * FROM telefonos

DELETE FROM organizaciones
    WHERE idOrganizacion = 1

SELECT * FROM telefonos

-----------------------------------------DisparadoresNoOk-----------------------------------------
--TG_OFICINAS_MO
--Dato del presupuesto invalido
UPDATE OFICINAS SET nombre= 'oficina xd', presupuesto = 'adgsd', encargado=32
WHERE nombre = 'Oficina de educacion'

--TG_OFICINAS_EL
--nombre de la oficina no existe
DELETE FROM OFICINAS 
WHERE nombre = 'Oficina educacion'

--TG_PROVEEDORES_AD
--El valor de la dirrecion es erroneo
INSERT INTO PROVEEDORES (nombre, id, direccion, correo)
    VALUES ('Carlos ', 5161, 518161 ,'algobsgfasfsfd.3lol@mail.com');

--TG_PROVEEDORES_AD
--El valor del correo es erroneo
UPDATE PROVEEDORES SET nombre= 'Andrea', id = 54451, direccion = 'Delladonna Place #2-7', correo = 4
WHERE id = 26
--TG_PROVEEDORES_EL

--TG_LINEASCOMPRAS_AD
--el  idBien no esxiste en la BD
INSERT INTO LINEASCOMPRAS (idBien, numeroCompra, cantidad)
    VALUES (1, 27, 10);

--TG_LINEASCOMPRAS_MO
--el valor del idBien es erroneo
UPDATE LINEASCOMPRAS SET idBien = 123, numerocompra = 51, cantidad = 15
WHERE idBien = 'as';

--TG_COMPRAS_AD
INSERT INTO COMPRAS (numero, fecha, nombreOficina)
    VALUES (68464, 3/05/2023, 'Oficina de gobierno');
    
--TG_COMPRAS_MO
--El valor de numero es erroneo
UPDATE COMPRAS SET numero = 123, fecha = '11/06/2019', nombreOficina = 'Oficina de desarrollo economico'
WHERE numero = 'fafa';

--TG_COMPRAS_EL
--El valor de numero es erroneo
DELETE FROM COMPRAS
WHERE numero = 'fsa';

--TG_CARPETAS_AD
--La oficina no existe
INSERT INTO CARPETAS(idCarpeta,nombreOficina,numeroCarpetas,estado)
    VALUES(1,'Oficina Paz',4,'Faltan documentos antecedentes');

--TG_CARPETAS_MO
--EL valor de idCarpeta es erroneo
UPDATE Carpetas SET idCarpeta=54,nombreoficina = 'Oficina de hacienda', numerocarpetas = 5, descripcion = '​​​​Es importante conocer cada parte de tu factura​​'
WHERE idcarpeta='qqwe';

--TG_CARPETAS_EL
--EL valor de idCarpeta es erroneo
DELETE FROM CARPETAS
WHERE idcarpeta = 'fasfa';

--TG_ORGANIZACIONES_AD
--EL valor del nit es erroneo
INSERT INTO ORGANIZACIONES (idOrganizacion, nombre, nit, direccion)
    VALUES (1,'Oncobiologics, Inc.','48159156199', 'Corscot Center #426-32');

--TG_ORGANIZACIONES_MO
--El valor de la direccion es erroneo
UPDATE ORGANIZACIONES SET idOrganizacion=5, nombre='UMH Properties, Inc.', nit=34238177100, direccion='Meadow Vale Crossing'
WHERE idOrganizacion=2;

--TG_ORGANIZACIONES_EL
DELETE FROM ORGANIZACIONES
    WHERE idOrganizacion = 15464

--TG_PROYECTOS_AD
--el IdOrganización no esta en la BD
INSERT INTO PROYECTOS(idOrganizacion,numeroContrato,descripcion,fechainicio) 
    VALUES(661,998,'Lavar un arbol','15/04/2023');

--TG_PROYECTOS_MO
--el dato de la fehca inicio que se intenta actualizar es erroneo
UPDATE PROYECTOS SET idProyecto = 541,idOrganizacion = 514,numeroContrato = 411,descripcion ='Construccion via vereda la Aurora' ,fechainicio = 14/03/2003
WHERE idProyecto=2;

--TG_PROYECTOS_EL
--El valor del proyecto es erroneo
DELETE FROM PROYECTOS
WHERE idProyecto = 'asd';

--XDisparadores
DROP TRIGGER TG_CARPETAS_AD;
DROP TRIGGER TG_CARPETAS_MO;
DROP TRIGGER TG_CARPETAS_EL;
DROP TRIGGER TG_ORGANIZACIONES_AD;
DROP TRIGGER TG_ORGANIZACIONES_MO;
DROP TRIGGER TG_ORGANIZACIONES_EL;
DROP TRIGGER TG_PROYECTOS_AD;
DROP TRIGGER TG_PROYECTOS_MO;
DROP TRIGGER TG_PROYECTOS_EL;