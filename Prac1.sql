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
  BEFORE INSERT ON depart
  FOR EACH ROW
DECLARE
  v_cod depart.dept_no%TYPE;
BEGIN
  SELECT dept_no INTO v_cod FROM depart WHERE UPPER(dnombre)= 'VENTAS';
  IF : NEW.dept_no = v_cod
    THEN RAISE_APPLICATION_ERROR (-20500, 'No se pueden insertar empleados en este departamento');
  END IF;
END no_emple_ventas;

--EJER4
CREATE OR REPLACE TRIGGER aumento_sal
  BEFORE UPDATE OF salario ON emple --SOLO CUANDO SE ACTUALICE LA COLUMNA SALARIO(por eso el of salario)
  FOR EACH ROW WHEN (NEW.salario > OLD.salario * 1.2)
BEGIN
   --RAISE_APPLICATION_ERROR (-20500, 'No se puede aumentar tanto el salario');
   dbms_output.put_line('No se puede aumentar tanto el salario');
END no_emple_ventas;

--EJER5
CREATE OR REPLACE TRIGGER trig
  INSTEAD OF INSERT ON EmpleadoDpto
  FOR EACH ROW
DECLARE
  v_depmax NUMBER(2);
  v_num NUMBER(2);
  v_nombre depart.dnombre%TYPE;
BEGIN
  FOR va IN (select dnombre FROM depart)
  LOOP
    IF va.dnombre = :new.dnombre
      THEN boo:=false;
    END IF;
  END LOOP;
  --SELECT dept_no INTO v_num FROM depart WHERE UPPER(dnombre) = UPPER(:NEW.dnombre);
  IF boo 
    THEN 
      SELECT NVL2(MAX(dept_no), dept_no + 10, 0) INTO v_num FROM depart;
      INSERT INTO emple VALUES (:NEW.emp_no, :NEW.apellido, null, null, sysdate, 0, 0, v_num);
  END IF;
  SELECT dept_no INTO v_num FROM depart WHERE UPPER(dnombre) = UPPER(:NEW.dnombre);
  /*ELSE  
    
  IF v_depmax < 90 
    THEN
      INSERT INTO depart VALUES (v_depmax, :new.dnombre, null);*/
      INSERT INTO emple VALUES (:NEW.emp_no, :NEW.apellido, null, null, sysdate, 0, 0, v_depmax);
  --ELSE
    --dbms_output.put_line('No se pueden insertar más departamentos');
  --END IF;
EXCEPTION
  WHEN no_data_found
END trig;




























/*PRIMERA PRACTICA CON PAQUETES*/