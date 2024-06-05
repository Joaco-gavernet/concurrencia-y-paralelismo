-- Problema: Se debe modelar la atención en un banco por medio de DOS empleados. Los clientes llegan y son atendidos de acuerdo al orden de llegada por cualquiera de los dos


Procedure Banco is
  Task Type Empleado;
  Task Type Cliente is
    entry respuesta(resultado: IN string);
  End Cliente;
  Task Administrador is
    entry siguiente(idC: OUT integer; datos: OUT string);
    entry pedido(id: IN integer; datosC: IN string);
  End Administrador;
  Task Asignador is
    entry ident(id: OUT integer);
  End Asignador;

  arrEmpleados: array(1..E) of Empleado;
  arrClientes: array(1..C) of Cliente;
  -- C y E constantes dadas

---------------------

  Task Body Empleado is
    idC: integer;
    datos: string;
  Begin
    loop
      Administrador.siguiente();
      resultado := procesar(datos);
      arrClientes[idC].respuesta(resultado);
    end loop;
  End Empleado;

  Task Body Cliente is
    id: integer;
    datos, resultadoLocal: string;
  Begin
    Asignador.ident(id);
    datos := generarDatos();
    Administrador.pedido(id,datos);
    accept respuesta(resultado: IN string) is
      resultadoLocal := resultado;
    end respuesta;
    retirarse();
  End Cliente;

  Task Body Administrador is
  Begin
    loop
      accept siguiente(idC: OUT integer; datos: OUT string) is
	accept pedido(id: IN integer; datosC: IN string) is
	  idC := id;
	  datos := datosC;
	end pedido;
      end siguiente;
    end loop;
  End Administrador;

  Task Body Asignador is
    i: integer;
  Begin
    for i in 1..C loop
      accept ident(id: OUT integer) is
	id := i;
      end ident;
    end loop;
  End Asignador;

---------------------

Begin
  null;
End Banco;

