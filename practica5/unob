// Problema: Se requiere modelar un puente de un solo sentido, el puente solo soporta el peso de 5 unidades de peso. Cada auto pesa 1 unidad, cada camioneta pesa 2 unidades y cada camión 3 unidades. Suponga que hay una cantidad innumerable de vehículos (A autos, B camionetas y C camiones).

b. Modifique la solución para que tengan mayor prioridad los camiones que el resto de los
vehículos.


Procedure Puente is
Task Type Auto
Task Type Camioneta
Task Type Camion
Task Puente is
	Entry autoOk();
	Entry camionetaOk();
	Entry camionOk();
End Puente;

arrAutos: array(1..A) of Auto;
arrCamionetas: array(1..B) of Camioneta;
arrCamion: array(1..C) of Camion;

///////////////////

Task Body Auto is
peso: const integer := 1;
Begin
	Puente.autoOk();
	transitarPuente();
	Puente.salida(peso);
End Auto;

Task Body Camioneta is
peso: const integer := 2;
Begin
	Puente.camionetaOk();
	transitarPuente();
	Puente.salida(peso);
End Auto;

Task Body Camion is
peso: const integer := 3;
Begin
	Puente.camionOk();
	transitarPuente();
	Puente.salida(peso);
End Auto;

Task Body Puente is
pesoActual: integer := 0;
Begin
	loop
		select 
			accept salida(peso: IN integer) do 
				pesoActual := pesoActual - peso;
			end salida;
			or when (camionOk'count = 0 and pesoActual + 1 <= 5) => accept autoOk();
			or when (camionOk'count = 0 and pesoActual + 2 <= 5) => accept camionetaOk();
			or when (pesoActual + 3 <= 5) => accept camionOk();
		end select;
	end loop;
End Puente;

///////////////////

Begin
	null
End Puente;

