-- Problema: En un sistema para acreditar carreras universitarias, hay UN Servidor que atiende pedidos de U Usuarios de a uno a la vez y de acuerdo al orden en que se hacen los pedidos. 

-- Cada usuario trabaja en el documento a presentar, y luego lo envía al servidor; espera la respuesta del mismo que le indica si está bien o hay algún error. Mientras haya algún error vuelve a trabajar con el documento y a enviarlo al servidor. 

-- Cuando el servidor le responde que está bien el usuario se retira. Cuando un usuario envía un pedido espera a lo sumo 2 minutos a que sea recibido por el servidor, pasado ese tiempo espera un minuto y vuelve a intentarlo (usando el mismo documento).



Procedure is

Task Servidor is
	Entry pedido(documento: IN string; exito: OUT boolean);
End Servidor;

Task Type Usuario;
arrUsuarios: array(1..U) of Usuario;

--------------------

Task Body Servidor is
Begin
	loop
		accept pedido(documento: IN string; exito: OUT boolean) is
			exito := procesar(documento);
		end pedido;
	end loop;
End Servidor;

Task Body Usuario is
	documento: string;
	same: boolean := false;
	exito: boolean := false;
Begin
	while exito = false loop
		if same = false then trabajar(documento);
		select
			Servidor.pedido(documento,exito);
		or delay 120
			exito := false;
			same := true;
			delay 60; -- espera solo si no fue recibido
		end select;
	end loop;
	retirarse();
End Usuario;

--------------------

Begin
	null
End;

