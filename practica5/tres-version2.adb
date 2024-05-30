// Problema: Se dispone de un sistema compuesto por 1 central y 2 procesos. Los procesos envían señales a la central. La central comienza su ejecución tomando una señal del proceso 1, luego toma aleatoriamente señales de cualquiera de los dos indefinidamente. Al recibir una señal de proceso 2, recibe señales del mismo proceso durante 3 minutos. 

El proceso 1 envía una señal que es considerada vieja (se deshecha) si en 2 minutos no fue recibida. 
El proceso 2 envía una señal, si no es recibida en ese instante espera 1 minuto y vuelve a
mandarla (no se deshecha).



Procedure Computadora is

Task Central is
	entry signalUno(datos: IN/OUT string);
	entry signalDos(datos: IN/OUT string);
End Central;

Task Primero;
Task Segundo;

-----------------------

Task Body Central is
datos, resultado: string;
restriccion: boolean := false;
Begin
	accept signalUno(datos) is
		resultado := procesar(datos);
		datos := resultado;
	end signalUno;

	loop
		select
			when (restriccion = true) => accept reset() is
				restriccion := false;
			end reset;
		or
			when (restriccion = false) => accept signalUno(datos) is
				resultado := procesar(datos);
				datos := resultado;
			end signalUno;
		or
			accept signalDos(datos) is
				resultado := procesar(datos);
				datos := resultado;
			end signalDos;
			if (restriccion = false) then
				restriccion := true;
				Timer.iniciar();
			end if;
		end select;
	end loop;
End Central;

Task Body Primero is
datos: string;
Begin
	loop
		datos := generarDatos();
		select
			Central.signalUno(datos);
			utilizarResultado(datos);
		or delay 120
			-- se desecha signal anterior y se crea una nueva
			datos := null;
		end select;
	end loop;
End Primero;

Task Body Segundo is
datos: string;
exito: boolean := false;
Begin
	loop
		if (exito = false) datos := generarDatos();
		select
			Central.signalDos(datos);
			exito := true;
			utilizarResultado(datos);
		or delay 60 
			exito := false;
		end select;
	end loop;
End Primero;

Task Body Timer is
Begin
	loop
		accept iniciar;
		delay 180
		Central.reset();
	end loop;
End Timer;

-------------------

Begin
	null;
End Computadora;
