-- Problema: En una playa hay 5 equipos de 4 personas cada uno (en total son 20 personas donde cada una conoce previamente a que equipo pertenece). Cuando las personas van llegando esperan con los de su equipo hasta que el mismo esté completo (hayan llegado los 4 integrantes), a partir de ese momento el equipo comienza a jugar. 

-- El juego consiste en que cada integrante del grupo junta 15 monedas de a una en una playa (las monedas pueden ser de 1, 2 o 5 pesos) y se suman los montos de las 60 monedas conseguidas en el grupo. 

-- Al finalizar cada persona debe conocer grupo que más dinero junto. Nota: maximizar la concurrencia. Suponga que para simular la búsqueda de una moneda por parte de una persona existe una función Moneda() que retorna el valor de la moneda encontrada.

Procedure Juego is

P: interger := 20;
T: integer := 5;
MAX: integer := 60;

Task Type Coordinador is
	Entry llegada;
	Entry pedido(monto: IN integer; fin: OUT boolean); 
End Coordinador;

Task Type Persona is
	Entry ganador(equipo: integer IN);
End Persona;

arrCoordinadores: array(1..T) of Coordinador;
arrPersonas: array(1..P) of Persona;

---------------------

Task Body Coordinador is
	cont: integer := 0;
	total: integer := 0;
	i: integer;
Begin
	-- esperar llegada del equipo para iniciar
	for i in 1..4 loop 
		accept llegada;
	end loop;

	-- iniciar busqueda
	while cont < MAX loop
		accept pedido(monto: IN integer; fin: OUT boolean) is
			total := total + monto;
			if (cont = MAX -1) then fin := true;
			else fin := false;
		end pedido;
		cont := cont +1;
	end loop;

	-- avisar finalizacion de busqueda a miembros del equipo
	while pedido'count > 0 loop
		accept pedido(monto: IN integer; fin: OUT boolean) is
			fin := true;
		end pedido;
	end loop;

	-- esperar resultado final
	for i in 1..T loop
	end loop;

	-- comunicar resultado a los miembros del equipo
	for i in 1..4 loop
	end loop;

End Coordinador;

Task Body Persona is
	monto: integer := 0;
	fin: boolean := false;
Begin
	-- se supone que la persona sabe cual es su equipo (myT)
	Coordinador(myT).llegada();

	while fin = false loop
		monto := Moneda();
		Coordinador(myT).pedido(monto,fin);
	end loop;

End Persona;

---------------------

Begin
	null;
End Juego;


