-- Problema: Una empresa de limpieza se encarga de recolectar residuos en una ciudad por medio de 3 camiones. Hay P personas que hacen continuos reclamos hasta que uno de los camiones pase por su casa. 

-- Cada persona hace un reclamo, espera a lo sumo 15 minutos a que llegue un camión y si no vuelve a hacer el reclamo y a esperar a lo sumo 15 minutos a que llegue un camión y así sucesivamente hasta que el camión llegue y recolecte los residuos; en ese momento deja de hacer reclamos y se va. 

-- Cuando un camión está libre la empresa lo envía a la casa de la persona que más reclamos ha hecho sin ser atendido. 
-- Nota: maximizar la concurrencia.


Procedure Program is

Task Administrador is
	entry siguiente(id: OUT integer);
	entry pedido(id: IN integer);
End Administrador;

Task Type Persona is
	entry ident(identificador: IN integer) is 
End Persona;

Task Type Camion;

arrCamiones: array(1..3) of Camion;
arrPersonas: array(1..P) of Persona;

-----------------------

Task Body Administrador is
	vector<integer> pedidosPorPersona(N,0); -- size N inicializado en 0
Begin
	loop
		select
			when(siguiente'count = 0) => accept pedido(id: IN integer) do 
				if (pedidosPorPersona(id) <> -1) then
					pedidosPorPersona(id) := pedidosPorPersona(id) +1;
			end pedido;
		or 
			accept siguiente(id: OUT integer) do 
				id := max(pedidosPorPersona);
				pedidosPorPersona(id) := -1; -- se indica que ya fue atendida
			end siguiente;
		end select;
	end loop;
End Administrador;

Task Body Camion is
Begin
	loop
		Administrador.siguiente(idP);
		atender(idP);
	end loop;
End Camion;

Task Body Persona is
	id: integer;
	direc: string;
	exito: boolean := false;
Begin
	accept ident(identificador: IN integer) do 
		id:= identificador;
	end ident;

	while (exito = false) loop
		Administrador.pedido(id);
		select
			accept recibir() do 
				exito := true;
			end recibir;
		or delay 15
		end select;
	end loop;
End Persona;

-----------------------

Begin
	for i in 1..P loop
		arrPersonas(i).ident(i);
	end loop;
End;
