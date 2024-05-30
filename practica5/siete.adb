-- Problema: Hay un sistema de reconocimiento de huellas dactilares de la policía que tiene 8 Servidores para realizar el reconocimiento, cada uno de ellos trabajando con una Base de Datos propia; a su vez hay un Especialista que utiliza indefinidamente. El sistema funciona de la siguiente manera: 

-- el Especialista toma una imagen de una huella (TEST) y se la envía a los servidores para que cada uno de ellos le devuelva el código y el valor de similitud de la huella que más se asemeja a TEST en su BD; al final del procesamiento, el especialista debe conocer el código de la huella con mayor valor de similitud entre las devueltas por los 8 servidores. Cuando ha terminado de procesar una huella comienza nuevamente el ciclo. 

-- Nota: suponga que existe una función Buscar(test, código, valor) que utiliza cada Servidor donde recibe como parámetro de entrada la huella test, y devuelve como parámetros de salida el código y el valor de similitud de la huella más parecida a test en la BD correspondiente. Maximizar la concurrencia y no generar demora innecesaria


Procedure Huellas is

	Task Especialista is
		entry muestra(m: OUT string);
		entry resultado(z: IN integer; porcentaje: IN integer);
	End Especialista;

	Task Type Servidor; 

	arrServidores: array(1..8) of Servidor;

----------------------

Task Body Especialista is 
	TEST: string;
	codigo, similitud: integer;
Begin
	loop
		similitud := -1;
		codigo := -1;

		TEST := tomarImagenDeHuella();

		for i in (1..16) loop
			select
				accept muestra(m: OUT string) do
					m := TEST;
				end muestra;
			or
				accept resultado(z: IN integer; porcentaje: IN integer) do 
					if (porcentaje > similitud) then
						codigo := z;
						similitud := porcentaje;
					end;
				end resultado;
			end select;
		end loop

	end loop;
End Especialista;

Task Body Servidor is
	m: string;
	codigo, porcentaje: integer;
Begin
	loop
		Especialista.muestra(m);
		Buscar(m,codigo,porcentaje);
		Especialista.resultado(codigo,porcentaje);
	end loop;
End Servidor;

----------------------

Begin
	null;
End;

