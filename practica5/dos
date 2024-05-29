// Problema: Se quiere modelar la cola de un banco que atiende un solo empleado, los clientes llegan y si esperan más de 10 minutos se retiran.


Procedure Banco is

Task Empleado is
	Entry atender(datos: IN/OUT string);
End Empleado;

Task Type Cliente 

arr: array(1..N) of Cliente;

//////////////////

Task Body Empleado is
Begin
	loop
		accept atender(datos: IN/OUT string) do 
			datos := resolver(datos);
		end atender;
	end loop;
End Empleado;

Task Body Cliente is
datosLocal: string;
Begin
	datosLocal := generarDatos();
	select 
		Empleado.atender(datosLocal);
	or delay 10
		null;
	end select;
	retirarse();
End Empleado;

//////////////////

Begin
	null
End Banco;
