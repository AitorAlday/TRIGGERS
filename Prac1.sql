/*PRIMERA PRACTICA CON TRIGGERS*/

--EJER1
CREATE OR REPLACE TRIGGER ins_emple
  BEFORE INSERT ON emple
BEGIN
  IF (TO_CHAR(SYSDATE,'HH24:MI') NOT BETWEEN '09:30' AND '17:30')
  OR (TO_CHAR(SYSDATE,'DY') IN ('SAB', 'DOM'))
    THEN RAISE_APPLICATION_ERROR (-20001, 'Solo se puede añadir personal entre algún tiempo');
  END IF;
END ins_emple;

--EJER2
CREATE OR REPLACE TRIGGER Control_Empleados
  AFTER INSERT OR DELETE OR UPDATE ON emple
  FOR EACH ROW
BEGIN
  IF INSERTING THEN
    INSERT INTO Ctrl_Empleados (Tabla, Usuario,Fecha, Oper)
    VALUES('Empleados', USER, SYSDATE, 'INSERT');
  ELSIF UPDATING THEN
    INSERT INTO Ctrl_Empleados (Tabla, Usuario,Fecha, Oper)
    VALUES('Empleados', USER, SYSDATE, 'UPDATE');
  ELSIF DELETING THEN
    INSERT INTO Ctrl_Empleados (Tabla, Usuario,Fecha, Oper)
    VALUES('Empleados', USER, SYSDATE, 'DELETE');
  ELSE RAISE_APPLICATION_ERROR (-20001, 'ERROR DESCONOCIDO');
  END IF;
END Control_Empleados;

--EJER3
CREATE OR REPLACE TRIGGER no_emple_ventas
  v_nombre depart.dnombre%TYPE;
  BEFORE INSERT ON depart
  FOR EACH ROW
BEGIN
  SELECT dnombre INTO v_nombre FROM depart;
  IF (UPPER(dnombre) = 'VENTAS')
    THEN RAISE_APPLICATION_ERROR (-20500, 'No se puden insertar empleados en este departamento');
  END IF;
END no_emple_ventas;

