BEGIN
    --Se registra un nuevo proveedor para realizar la compra
    PK_ENCARGADO.PROVEEDORESAD('Pintuco', 'Lakeland Park #60-031', 'Pintuco@gmail.com')
    --Registrar compra
    PK_ENCARGADO.COMPRASAD('Oficina de gobierno');
    --Crear los bienes que se van a adquirir
    PK_ENCARGADO.Bienes_ServiciosAd(1, 100000, 'Pintar oficina', SYSDATE, 'P', 100, 1);
    PK.ENCARGADO.Bienes_ProductosAd(1, 50000, 'Pintura', 0, 101, 1);
    --Se añaden las lineas de compra
    PK_ENCARGADO.LineasCompraAd(100, 1, 1);
    PK_ENCARGADO.LineasCompraAd(101, 1, 1);
    --Se consulta el presupuesto de la oficina 
END;
--Se consulta el presupuesto de la oficina
DECLARE
    OFICINA_CONSULTA SYS_REFCURSOR;
BEGIN
    OFICINA_CONSULTA:=PK_ENCARGADO.ConsultaPresupuesto('Oficina de gobierno');
    DBMS_SQL.RETURN_RESULT(OFICINA_CONSULTA);
END;