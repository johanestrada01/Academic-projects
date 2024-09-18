BEGIN
    --Añadimos compañia con la que se realizara el contrato
    PC_EMPLEADO.ORGANIZACIONESAD_('ARGOS', 12345, 'Lakeland Park #60-031');
    --Añadimos la carpeta perteneciente a la empresa
    PC_EMPLEADO.CARPETAS_CONTRATOAD_('Oficina de gobierno','Empresa encargada de proveer material y realizar las obras', 'Incompleta', 123, 'Pavimentar una via rural' ,100000000);
   --Se crea el proyecto que se va a realizar
   PC_EMPLEADO.PROYECTOSAD_(1, 1, 123, 'Pavimentar una via rural'); 
END;