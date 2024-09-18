---------------------------------------------------------------------------CRUDI---------------------------------------------------------------------------
--PK_OFICINAS
CREATE OR REPLACE PACKAGE PK_OFICINAS AS
    PROCEDURE OficinasMo(Onombre OFICINAS.nombre%TYPE, Npresupuesto OFICINAS.presupuesto%TYPE, Nencargado OFICINAS.encargado%TYPE);
    FUNCTION ConsultaOficina RETURN SYS_REFCURSOR;
    FUNCTION ConsultaPresupuesto (Cnombre IN VARCHAR) RETURN SYS_REFCURSOR;
END PK_OFICINAS;
/
CREATE OR REPLACE PACKAGE BODY PK_OFICINAS IS
    PROCEDURE OficinasMo(Onombre OFICINAS.nombre%TYPE, Npresupuesto OFICINAS.presupuesto%TYPE, Nencargado OFICINAS.encargado%TYPE) IS
        BEGIN
            UPDATE OFICINAS SET presupuesto = Npresupuesto, encargado = Nencargado WHERE nombre = Onombre;
    END OficinasMo;
    FUNCTION ConsultaOficina RETURN SYS_REFCURSOR IS
        TABLE_CO SYS_REFCURSOR;
        BEGIN
            OPEN TABLE_CO FOR SELECT * FROM OFICINAS;
            RETURN TABLE_CO;
    END ConsultaOficina;
    FUNCTION ConsultaPresupuesto (Cnombre IN VARCHAR) RETURN SYS_REFCURSOR IS
        TABLE_CP SYS_REFCURSOR;
        BEGIN
            OPEN TABLE_CP FOR SELECT presupuesto, encargado FROM OFICINAS WHERE Cnombre = nombre;
            RETURN TABLE_CP;
    END ConsultaPresupuesto;
END; 
/
--PK_BIENES
CREATE OR REPLACE PACKAGE PK_BIENES AS
    PROCEDURE Bienes_ServiciosAd(NidServicio SERVICIOS.idServicio%TYPE, Nprecio SERVICIOS.precio%TYPE, Nnombre SERVICIOS.nombre%TYPE, NfechaPago SERVICIOS.fechaPago%TYPE, Nestado SERVICIOS.estado%TYPE, NidBien BIENESOFRECIDOS.idBien%TYPE, Nproveedor BIENESOFRECIDOS.idProveedor%TYPE);
    PROCEDURE Bienes_ProductosAd(NidProducto PRODUCTOS.idProducto%TYPE, Nprecio PRODUCTOS.precio%TYPE, Nnombre PRODUCTOS.nombre%TYPE, NunidadesActuales PRODUCTOS.unidadesActuales%TYPE,NidBien BIENESOFRECIDOS.idBien%TYPE, Nproveedor BIENESOFRECIDOS.idProveedor%TYPE);
    PROCEDURE Bienes_ServiciosMo(OidServicio SERVICIOS.idServicio%TYPE, Nprecio SERVICIOS.precio%TYPE, NfechaPago SERVICIOS.fechaPago%TYPE, Nestado SERVICIOS.estado%TYPE);
    PROCEDURE Bienes_ProductosMo(OidProducto PRODUCTOS.idProducto%TYPE, Nprecio PRODUCTOS.precio%TYPE, NunidadesActuales PRODUCTOS.unidadesActuales%TYPE);
    PROCEDURE Bienes_ServiciosEl(OidServicio SERVICIOS.idServicio%TYPE);
    PROCEDURE Bienes_ProductosEl(OidProducto PRODUCTOS.idProducto%TYPE);
    FUNCTION ConsultaServicios (CnombreOficina IN VARCHAR) RETURN SYS_REFCURSOR;
    FUNCTION ConsultaProductos (CnombreOficina IN VARCHAR) RETURN SYS_REFCURSOR;
END PK_BIENES;
/
CREATE OR REPLACE PACKAGE BODY PK_BIENES IS
    PROCEDURE Bienes_ServiciosAd(NidServicio SERVICIOS.idServicio%TYPE, Nprecio SERVICIOS.precio%TYPE, Nnombre SERVICIOS.nombre%TYPE, NfechaPago SERVICIOS.fechaPago%TYPE, Nestado SERVICIOS.estado%TYPE, NidBien BIENESOFRECIDOS.idBien%TYPE, Nproveedor BIENESOFRECIDOS.idproveedor%TYPE) IS
        BEGIN
            INSERT INTO SERVICIOS (idServicio, precio, nombre, fechaPago, estado) VALUES (NidServicio, Nprecio, Nnombre, NfechaPago, Nestado);
            INSERT INTO BIENESOFRECIDOS (idBien, idServicio, idProducto, idProveedor) VALUES (NidBien, NidServicio, NULL, Nproveedor);
    END Bienes_ServiciosAd;
    PROCEDURE Bienes_ProductosAd(NidProducto PRODUCTOS.idProducto%TYPE, Nprecio PRODUCTOS.precio%TYPE, Nnombre PRODUCTOS.nombre%TYPE, NunidadesActuales PRODUCTOS.unidadesActuales%TYPE,NidBien BIENESOFRECIDOS.idBien%TYPE, Nproveedor BIENESOFRECIDOS.idproveedor%TYPE) IS
        BEGIN
            INSERT INTO PRODUCTOS (idProducto, precio, nombre, unidadesActuales) VALUES (NidProducto, Nprecio, Nnombre, NunidadesActuales);
            INSERT INTO BIENESOFRECIDOS (idBien, idServicio, idProducto, idProveedor) VALUES (NidBien, Null, NidProducto, Nproveedor);
    END Bienes_ProductosAd;
    PROCEDURE Bienes_ServiciosMo(OidServicio SERVICIOS.idServicio%TYPE, Nprecio SERVICIOS.precio%TYPE, NfechaPago SERVICIOS.fechaPago%TYPE, Nestado SERVICIOS.estado%TYPE) IS
        BEGIN
            UPDATE SERVICIOS SET precio = Nprecio, fechaPago = NfechaPago, estado = Nestado WHERE idServicio = OidServicio;
    END Bienes_ServiciosMo;
    PROCEDURE Bienes_ProductosMo(OidProducto PRODUCTOS.idProducto%TYPE, Nprecio PRODUCTOS.precio%TYPE, NunidadesActuales PRODUCTOS.unidadesActuales%TYPE) IS
        BEGIN
            UPDATE PRODUCTOS SET precio = Nprecio, unidadesActuales = NunidadesActuales WHERE idProducto = OidProducto;
    END Bienes_ProductosMo;
    PROCEDURE Bienes_ServiciosEl(OidServicio SERVICIOS.idServicio%TYPE) IS
        BEGIN
            DELETE FROM SERVICIOS WHERE idServicio = OidServicio;
            DELETE FROM BIENESOFRECIDOS WHERE idServicio = OidServicio;
    END Bienes_ServiciosEl;
    PROCEDURE Bienes_ProductosEl(OidProducto PRODUCTOS.idProducto%TYPE) IS
        BEGIN
            DELETE FROM PRODUCTOS WHERE idProducto = OidProducto;
            DELETE FROM BIENESOFRECIDOS WHERE idProducto = OidProducto;
    END Bienes_ProductosEl;
    FUNCTION ConsultaServicios (CnombreOficina IN VARCHAR) RETURN SYS_REFCURSOR IS
        TABLE_CBS SYS_REFCURSOR;
        BEGIN
            OPEN TABLE_CBS FOR SELECT BIENESOFRECIDOS.idBien, LINEASCOMPRAS.cantidad, SERVICIOS.nombre, PROVEEDORES.nombre FROM  COMPRAS
                JOIN LINEASCOMPRAS ON (COMPRAS.numero = LINEASCOMPRAS.numeroCompra)
                JOIN BIENESOFRECIDOS ON (BIENESOFRECIDOS.idBien = LINEASCOMPRAS.idBien)
                JOIN SERVICIOS ON (SERVICIOS.idServicio = BIENESOFRECIDOS.idServicio)
                JOIN PROVEEDORES ON (PROVEEDORES.id = BIENESOFRECIDOS.idProveedor)
                WHERE COMPRAS.nombreOficina = CnombreOficina;
            RETURN TABLE_CBS;
    END ConsultaServicios;
    FUNCTION ConsultaProductos (CnombreOficina IN VARCHAR) RETURN SYS_REFCURSOR IS
        TABLE_CBB SYS_REFCURSOR;
        BEGIN
            OPEN TABLE_CBB FOR SELECT BIENESOFRECIDOS.idBien, LINEASCOMPRAS.cantidad, PRODUCTOS.nombre, PROVEEDORES.nombre FROM  COMPRAS
                JOIN LINEASCOMPRAS ON (COMPRAS.numero = LINEASCOMPRAS.numeroCompra)
                JOIN BIENESOFRECIDOS ON (BIENESOFRECIDOS.idBien = LINEASCOMPRAS.idBien)
                JOIN PRODUCTOS ON (PRODUCTOS.idProducto = BIENESOFRECIDOS.idProducto)
                JOIN PROVEEDORES ON (PROVEEDORES.id = BIENESOFRECIDOS.idProveedor)
                WHERE COMPRAS.nombreOficina = CnombreOficina;
            RETURN TABLE_CBB;
    END ConsultaProductos;
END; 
/

--PK_COMPRAS
CREATE OR REPLACE PACKAGE PK_COMPRAS AS
    PROCEDURE ComprasAd(NnombreOficina COMPRAS.nombreOficina%TYPE);
    PROCEDURE ComprasEl(Onumero COMPRAS.numero%TYPE);
    PROCEDURE LineasCompraAd(NidBien LINEASCOMPRAS.idBien%TYPE, NnumeroCompra LINEASCOMPRAS.numeroCompra%TYPE, Ncantidad LINEASCOMPRAS.cantidad%TYPE);
END PK_COMPRAS;
/
CREATE OR REPLACE PACKAGE BODY PK_COMPRAS IS
    PROCEDURE ComprasAd(NnombreOficina COMPRAS.nombreOficina%TYPE) IS
        BEGIN  
            INSERT INTO COMPRAS (nombreOficina) VALUES (NnombreOficina);
    END ComprasAd;
    PROCEDURE ComprasEl(Onumero COMPRAS.numero%TYPE) IS
        BEGIN
            DELETE FROM COMPRAS WHERE numero = Onumero;
    END ComprasEl;
    PROCEDURE LineasCompraAd(NidBien LINEASCOMPRAS.idBien%TYPE, NnumeroCompra LINEASCOMPRAS.numeroCompra%TYPE, Ncantidad LINEASCOMPRAS.cantidad%TYPE) IS
        BEGIN
            INSERT INTO LINEASCOMPRAS(idBien, numeroCompra, cantidad) VALUES (NidBien, NnumeroCompra, Ncantidad);
    END LineasCompraAd;
END;
/        
--PC_CARPETAS
CREATE OR REPLACE PACKAGE PC_CARPETAS AS
    PROCEDURE CARPETASAD(NOMBREOFICINA_AD CARPETAS.NOMBREOFICINA%TYPE, DESCRIPCION_AD CARPETAS.DESCRIPCION%TYPE, ESTADO_AD CARPETAS.ESTADO%TYPE);
    PROCEDURE CARPETASMO(N_NOMBREOFICINA CARPETAS.NOMBREOFICINA%TYPE, N_NUMEROCARPETAS CARPETAS.NUMEROCARPETAS%TYPE, N_DESCRIPCION CARPETAS.DESCRIPCION%TYPE, N_ESTADO CARPETAS.ESTADO%TYPE, ID_MO CARPETAS.IDCARPETA%TYPE);
    PROCEDURE CARPETASEL(ID_CARPETA CARPETAS.IDCARPETA%TYPE);
    FUNCTION CONSULTARCARPETAS(ID_CARPETA CARPETAS.IDCARPETA%TYPE) RETURN SYS_REFCURSOR;
END PC_CARPETAS;
/
CREATE OR REPLACE PACKAGE BODY PC_CARPETAS IS
    PROCEDURE CARPETASAD(NOMBREOFICINA_AD CARPETAS.NOMBREOFICINA%TYPE, DESCRIPCION_AD CARPETAS.DESCRIPCION%TYPE, ESTADO_AD CARPETAS.ESTADO%TYPE) IS
        BEGIN
            INSERT INTO CARPETAS(IDCARPETA, NOMBREOFICINA, NUMEROCARPETAS, ESTADO) VALUES(1, NOMBREOFICINA_AD, 1, ESTADO_AD);
    END CARPETASAD;
    PROCEDURE CARPETASMO(N_NOMBREOFICINA CARPETAS.NOMBREOFICINA%TYPE, N_NUMEROCARPETAS CARPETAS.NUMEROCARPETAS%TYPE, N_DESCRIPCION CARPETAS.DESCRIPCION%TYPE, N_ESTADO CARPETAS.ESTADO%TYPE, ID_MO CARPETAS.IDCARPETA%TYPE) IS
        BEGIN
            UPDATE CARPETAS SET NOMBREOFICINA=N_NOMBREOFICINA, NUMEROCARPETAS=N_NUMEROCARPETAS, DESCRIPCION=N_DESCRIPCION, ESTADO=N_ESTADO WHERE ID_MO=IDCARPETA;
    END CARPETASMO;
    PROCEDURE CARPETASEL(ID_CARPETA CARPETAS.IDCARPETA%TYPE) IS 
        BEGIN
            DELETE FROM CARPETAS WHERE IDCARPETA=ID_CARPETA;
    END CARPETASEL;
    FUNCTION CONSULTARCARPETAS(ID_CARPETA CARPETAS.IDCARPETA%TYPE) RETURN SYS_REFCURSOR IS
        TABLE_CARPETAS SYS_REFCURSOR;
        BEGIN
            OPEN TABLE_CARPETAS FOR SELECT NOMBREOFICINA, NUMEROCARPETAS, DESCRIPCION, ESTADO FROM CARPETAS WHERE ID_CARPETA=IDCARPETA;
            RETURN TABLE_CARPETAS;
    END CONSULTARCARPETAS;  
END;
/
--PC_ORGANIZACIONES
CREATE OR REPLACE PACKAGE PC_ORGANIZACIONES IS
    PROCEDURE ORGANIZACIONESAD(NOMBRE_AD ORGANIZACIONES.NOMBRE%TYPE, NIT_AD ORGANIZACIONES.NIT%TYPE, DIRECCION_AD ORGANIZACIONES.DIRECCION%TYPE);
    PROCEDURE ORGANIZACIONESMO(N_NOMBRE ORGANIZACIONES.NOMBRE%TYPE, N_DIRECCION ORGANIZACIONES.DIRECCION%TYPE, ID_MO ORGANIZACIONES.IDORGANIZACION%TYPE);
    PROCEDURE ORGANIZACIONESEL(IDORGANIZACION_EL ORGANIZACIONES.IDORGANIZACION%TYPE);
    FUNCTION CONSULTARORGANIZACIONES(ID ORGANIZACIONES.IDORGANIZACION%TYPE) RETURN SYS_REFCURSOR;
END PC_ORGANIZACIONES;
/
CREATE OR REPLACE PACKAGE BODY PC_ORGANIZACIONES IS
    PROCEDURE ORGANIZACIONESAD(NOMBRE_AD ORGANIZACIONES.NOMBRE%TYPE, NIT_AD ORGANIZACIONES.NIT%TYPE, DIRECCION_AD ORGANIZACIONES.DIRECCION%TYPE) IS
        BEGIN
            INSERT INTO ORGANIZACIONES(IDORGANIZACION, NOMBRE, NIT, DIRECCION) VALUES(1, NOMBRE_AD, NIT_AD, DIRECCION_AD);
    END ORGANIZACIONESAD;
    PROCEDURE  ORGANIZACIONESMO(N_NOMBRE ORGANIZACIONES.NOMBRE%TYPE, N_DIRECCION ORGANIZACIONES.DIRECCION%TYPE, ID_MO ORGANIZACIONES.IDORGANIZACION%TYPE) IS
        BEGIN
            UPDATE ORGANIZACIONES SET NOMBRE=N_NOMBRE, DIRECCION=N_DIRECCION WHERE IDORGANIZACION=ID_MO;
    END ORGANIZACIONESMO;
    PROCEDURE ORGANIZACIONESEL(IDORGANIZACION_EL ORGANIZACIONES.IDORGANIZACION%TYPE) IS
        BEGIN
            DELETE FROM ORGANIZACIONES WHERE IDORGANIZACION=IDORGANIZACION_EL;
    END ORGANIZACIONESEL;
    FUNCTION CONSULTARORGANIZACIONES(ID ORGANIZACIONES.IDORGANIZACION%TYPE) RETURN SYS_REFCURSOR IS
        TABLE_ORGANIZACIONES SYS_REFCURSOR;
        BEGIN
            OPEN TABLE_ORGANIZACIONES FOR SELECT * FROM V_ORGANIZACIONES;
            RETURN TABLE_ORGANIZACIONES;
    END CONSULTARORGANIZACIONES;
END;
/
--PC_PROVEEDORES
CREATE OR REPLACE PACKAGE PC_PROVEEDORES IS
    PROCEDURE PROVEEDORESAD(NOMBRE_AD PROVEEDORES.NOMBRE%TYPE, DIRECCION_AD PROVEEDORES.DIRECCION%TYPE, CORREO_AD PROVEEDORES.CORREO%TYPE);
    PROCEDURE PROVEEDORESMO(N_DIRECCION PROVEEDORES.DIRECCION%TYPE, N_CORREO PROVEEDORES.CORREO%TYPE, ID_MO PROVEEDORES.ID%TYPE);
    PROCEDURE PROVEEDORESEL(ID_PROVEEDOR PROVEEDORES.ID%TYPE);
END PC_PROVEEDORES;
/
CREATE OR REPLACE PACKAGE BODY PC_PROVEEDORES IS
    PROCEDURE PROVEEDORESAD(NOMBRE_AD PROVEEDORES.NOMBRE%TYPE, DIRECCION_AD PROVEEDORES.DIRECCION%TYPE, CORREO_AD PROVEEDORES.CORREO%TYPE) IS
        BEGIN
        INSERT INTO PROVEEDORES(NOMBRE, ID, DIRECCION, CORREO) VALUES(NOMBRE_AD, 1, DIRECCION_AD, CORREO_AD);
    END PROVEEDORESAD;
    PROCEDURE PROVEEDORESMO(N_DIRECCION PROVEEDORES.DIRECCION%TYPE, N_CORREO PROVEEDORES.CORREO%TYPE, ID_MO PROVEEDORES.ID%TYPE) IS
        BEGIN
        UPDATE PROVEEDORES SET DIRECCION=N_DIRECCION, CORREO=N_CORREO WHERE ID=ID_MO;
    END PROVEEDORESMO;
    PROCEDURE PROVEEDORESEL(ID_PROVEEDOR PROVEEDORES.ID%TYPE) IS
        BEGIN
        DELETE FROM PROVEEDORES WHERE ID_PROVEEDOR=ID;
    END PROVEEDORESEL;
END;
/
--PC_PROYECTOS
CREATE OR REPLACE PACKAGE PC_PROYECTOS IS
    PROCEDURE PROYECTOSAD(IDORGANIZACION_AD PROYECTOS.IDORGANIZACION%TYPE, NUMEROCONTRATO_AD PROYECTOS.NUMEROCONTRATO%TYPE, DESCRIPCION_AD PROYECTOS.DESCRIPCION%TYPE);
    PROCEDURE PROYECTOSMO(N_FECHAFIN PROYECTOS.FECHAFIN%TYPE, N_DESCRIPCION PROYECTOS.DESCRIPCION%TYPE, IDPROYECTO_MO PROYECTOS.IDPROYECTO%TYPE);
    PROCEDURE PROYECTOSEL(IDPROYECTO_EL PROYECTOS.IDPROYECTO%TYPE);
END PC_PROYECTOS;
/
CREATE OR REPLACE PACKAGE BODY PC_PROYECTOS IS
    PROCEDURE PROYECTOSAD(IDORGANIZACION_AD PROYECTOS.IDORGANIZACION%TYPE, NUMEROCONTRATO_AD PROYECTOS.NUMEROCONTRATO%TYPE, DESCRIPCION_AD PROYECTOS.DESCRIPCION%TYPE) IS
        BEGIN
        INSERT INTO PROYECTOS(IDPROYECTO, IDORGANIZACION, NUMEROCONTRATO, DESCRIPCION, FECHAINICIO) VALUES(1, IDORGANIZACION_AD, NUMEROCONTRATO_AD, DESCRIPCION_AD, SYSDATE);
    END PROYECTOSAD;
    PROCEDURE PROYECTOSMO(N_FECHAFIN PROYECTOS.FECHAFIN%TYPE, N_DESCRIPCION PROYECTOS.DESCRIPCION%TYPE, IDPROYECTO_MO PROYECTOS.IDPROYECTO%TYPE) IS
        BEGIN
        UPDATE PROYECTOS SET FECHAFIN=N_FECHAFIN, DESCRIPCION=N_DESCRIPCION WHERE IDPROYECTO=IDPROYECTO_MO;
    END PROYECTOSMO;
    PROCEDURE PROYECTOSEL(IDPROYECTO_EL PROYECTOS.IDPROYECTO%TYPE) IS
        BEGIN
        DELETE FROM PROYECTOS WHERE IDPROYECTO=IDPROYECTO_EL;
    END PROYECTOSEL;
END;
/
---------------------------------------------------------------------------XCRUD---------------------------------------------------------------------------
DROP PACKAGE PK_OFICINAS;
DROP PACKAGE PK_BIENES;
DROP PACKAGE PK_COMPRAS;
DROP PACKAGE PC_CARPETAS;
DROP PACKAGE PC_ORGANIZACIONES;
DROP PACKAGE PC_PROVEEDORES;
DROP PACKAGE PC_PROYECTOS;
---------------------------------------------------------------------------CRUDOK---------------------------------------------------------------------------
--PK_OFICINAS
DECLARE 
    T_ConsultaOficina SYS_REFCURSOR;
    T_ConsultaPresupuesto SYS_REFCURSOR;
    
BEGIN
    PK_OFICINAS.oficinasmo('Oficina de gobierno', 1381351, 212);
    T_ConsultaOficina := PK_OFICINAS.ConsultaOficina;
    DBMS_SQL.RETURN_RESULT(T_ConsultaOficina);
    T_ConsultaPresupuesto := PK_OFICINAS.ConsultaPresupuesto('Oficina general');
    DBMS_SQL.RETURN_RESULT(T_ConsultaPresupuesto);
END;

--PK_BIENES
INSERT INTO BIENESOFRECIDOS (idBien, idProducto, idProveedor)
    VALUES (200, 20, 6);
INSERT INTO BIENESOFRECIDOS (idBien, idServicio, idProveedor)
    VALUES (10, 10, 20);
    
INSERT INTO LINEASCOMPRAS (idBien, numeroCompra, cantidad)
    VALUES (200, 1, 10);
INSERT INTO LINEASCOMPRAS (idBien, numeroCompra, cantidad)
    VALUES (10, 5, 1);
DECLARE 
    T_ConsultaProductos SYS_REFCURSOR;
    T_ConsultaServicios SYS_REFCURSOR;
BEGIN
    PK_BIENES.bienes_serviciosad(15, 2000, 'luz', '15/06/2023', 'P', 40, 14); --idServicio, precio, nombre, fecha pago, estado, idbien, idproveedor
    PK_BIENES.bienes_productosad(30, 2134, 'papel', 20, 50, 7); --idProducto, precio, nombre, cantidad actual, idbien, idproveedor
    PK_BIENES.bienes_serviciosmo(15, 3000, '30/05/2023', 'N'); --idServicio, nuevo precio, nueva fecha pago, nuevo estado
    PK_BIENES.bienes_productosmo(30, 500, 20);--idProducto, nuevo precio, nueva cantidad
    PK_BIENES.bienes_serviciosel(8);
    PK_BIENES.bienes_productosel(7);
    T_ConsultaProductos := PK_BIENES.ConsultaProductos('Oficina de educacion');
    DBMS_SQL.RETURN_RESULT(T_ConsultaProductos);
    T_ConsultaServicios := PK_BIENES.ConsultaServicios('Oficina de educacion');
    DBMS_SQL.RETURN_RESULT(T_ConsultaServicios);
END;

--PK_COMPRAS
BEGIN
    PK_COMPRAS.Comprasad('Oficina de hacienda'); --nombre oficina
    PK_COMPRAS.Comprasel(10); --numero compra
    PK_COMPRAS.lineascompraad(1, 4, 4); --id bien, numero compra, cantidad
END;
--PC_CARPETAS
DECLARE
    T_CONSULTARCARPETAS SYS_REFCURSOR;
BEGIN
    PC_CARPETAS.carpetasad('Oficina de gobierno', 'velit eu est congue elementum in ', 'luctus et ultrices posuere cubilia curae nulla'); --nombre oficina, descripcion, estado
    PC_CARPETAS.carpetasmo('Oficina de hacienda', 3,'velit eu est congue elementum in ', 'luctus et ultrices posuere cubilia curae nulla', 40); --nombre oficina, numero de carpetas, descripcion, estado, id de carpeta a modificar
    PC_CARPETAS.carpetasel(51); --id carpeta a eliminar
    T_CONSULTARCARPETAS := PC_CARPETAS.CONSULTARCARPETAS(10);
    DBMS_SQL.RETURN_RESULT(T_CONSULTARCARPETAS);
END;

--PC_ORGANIZACIONES
DECLARE
    T_CONSULTARORGANIZACIONES SYS_REFCURSOR;
BEGIN
    PC_ORGANIZACIONES.organizacionesad('mosters inc', 135161151 , '#21-3 Walton Street'); --nombre organizacion, nir organizacion, direccion organizacion
    PC_ORGANIZACIONES.organizacionesmo('ACME', '#8-43 Brown Terrace', 7); --nuevo nombre organizacion, nueva direccion organizacion, id organizacion a cambiar
    PC_ORGANIZACIONES.organizacionesel(20); --id organizacion a eliminar
    T_CONSULTARORGANIZACIONES := PC_ORGANIZACIONES.CONSULTARORGANIZACIONES(10);
    DBMS_SQL.RETURN_RESULT(T_CONSULTARORGANIZACIONES);
END;
--Proyectos
BEGIN
    PC_PROYECTOS.PROYECTOSAD(1, 19, 'REPARACION CARRETERA');
    PC_PROYECTOS.PROYECTOSMO('31/12/2023', 'REPARACION CARRETERA', 1);
    PC_PROYECTOS.PROYECTOSEL(1);
END;

--Proveedores
BEGIN
    PC_PROVEEDORES.PROVEEDORESAD('Claro',98 ,'AK 46 #204-7', 'representante@claro.com');
    PC_PROVEEDORES.PROVEEDORESMO('AK 46 #204-7','representante@claro.com', 98);
    PC_PROVEEDORES.PROVEEDORESEL(98);
END;

---------------------------------------------------------------------------CRUDNoOK---------------------------------------------------------------------------
DECLARE 
    T_ConsultaOficina SYS_REFCURSOR;
    T_ConsultaPresupuesto SYS_REFCURSOR;
    
BEGIN
    PK_OFICINAS.oficinasmo('Oficina de ', 1381351, 212);                    --Ofina no existe
    T_ConsultaOficina := PK_OFICINAS.ConsultaOficina;
    DBMS_SQL.RETURN_RESULT(T_ConsultaOficina);
    T_ConsultaPresupuesto := PK_OFICINAS.ConsultaPresupuesto('Oficina ');   --Ofina no existe
    DBMS_SQL.RETURN_RESULT(T_ConsultaPresupuesto);
END;

--PK_BIENES
DECLARE 
    T_ConsultaProductos SYS_REFCURSOR;
    T_ConsultaServicios SYS_REFCURSOR;
BEGIN
    PK_BIENES.bienes_serviciosad(2, 2000, 'luz', '15/06/2023', 'P', 41, 14); --el id servicio ya está en la BD
    PK_BIENES.bienes_productosad(31, 2134, 'papel', 20, 555, 7); --el id bien ya está en la BD
    PK_BIENES.bienes_serviciosmo(200, 3000, '30/05/2023', 'N'); --el servicio no está en la BD
    PK_BIENES.bienes_productosmo(-2, 500, 20); --el producto no está en la BD
    PK_BIENES.bienes_serviciosel(5);
    PK_BIENES.bienes_productosel(9);
    T_ConsultaProductos := PK_BIENES.ConsultaProductos('Oficina' ); --no existe la oficina
    DBMS_SQL.RETURN_RESULT(T_ConsultaProductos);
    T_ConsultaServicios := PK_BIENES.ConsultaServicios('educacion'); --no existe la oficina
    DBMS_SQL.RETURN_RESULT(T_ConsultaServicios);
END;

--PK_COMPRAS
BEGIN
    PK_COMPRAS.Comprasad('Oficina '); --no existe la oficina
    PK_COMPRAS.Comprasel(2000); --la compra no esta en la BD
    PK_COMPRAS.lineascompraad(1, 4, 4); --id bien, numero compra, cantidad
END;

--PC_CARPETAS
DECLARE
    T_CONSULTARCARPETAS SYS_REFCURSOR;
BEGIN
    PC_CARPETAS.carpetasad('Oficina de gobierno', 'velit eu est congue elementum in ', 'luctus et ultrices posuere cubilia curae nulla'); 
    PC_CARPETAS.carpetasmo('Oficina de hacienda', 3,'velit eu est congue elementum in ', 'luctus et ultrices posuere cubilia curae nulla', 40); 
    PC_CARPETAS.carpetasel(51); 
    T_CONSULTARCARPETAS := PC_CARPETAS.CONSULTARCARPETAS('Oficina de hacienda');--el valor ingresado no es el correcto para la cansulta
    DBMS_SQL.RETURN_RESULT(T_CONSULTARCARPETAS);
END;

--PC_ORGANIZACIONES
DECLARE
    T_CONSULTARORGANIZACIONES SYS_REFCURSOR;
BEGIN
    PC_ORGANIZACIONES.organizacionesad('mosters inc', 135161151 , '#21-3 Walton Street'); --nombre organizacion, nir organizacion, direccion organizacion
    PC_ORGANIZACIONES.organizacionesmo('ACME', '#8-43 Brown Terrace', 7); --nuevo nombre organizacion, nueva direccion organizacion, id organizacion a cambiar
    PC_ORGANIZACIONES.organizacionesel(20); --id organizacion a eliminar
    T_CONSULTARORGANIZACIONES := PC_ORGANIZACIONES.CONSULTARORGANIZACIONES('10');--el valor ingresado no es el correcto para la cansulta
    DBMS_SQL.RETURN_RESULT(T_CONSULTARORGANIZACIONES);
END;

--Proyectos
BEGIN
    PC_PROYECTOS.PROYECTOSAD(19, 'REPARACION CARRETERA'); --Datos insuficientes
    PC_PROYECTOS.PROYECTOSMO(31/12/2023, 'REPARACION CARRETERA', 1); --Fecha no valida
    PC_PROYECTOS.PROYECTOSEL('uno'); --Id no valido
END;

--Proveedores
BEGIN
    PC_PROVEEDORES.PROVEEDORESAD('Claro' ,'AK 46 #204-7', 'representante@claro.com'); --Proveedor sin ID
    PC_PROVEEDORES.PROVEEDORESMO('AK 46 #204-7',3144789888, 98); --Correo no valido
    PC_PROVEEDORES.PROVEEDORESEL('98'); --Formato no valido
END;