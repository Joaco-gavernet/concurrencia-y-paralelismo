-- Problema: En una clínica existe un médico de guardia que recibe continuamente peticiones de atención de las E enfermeras que trabajan en su piso y de las P personas que llegan a la clínica ser atendidos. 

-- Cuando una persona necesita que la atiendan espera a lo sumo 5 minutos a que el médico lo haga, si pasado ese tiempo no lo hace, espera 10 minutos y vuelve a requerir la atención del médico. Si no es atendida tres veces, se enoja y se retira de la clínica.

-- Cuando una enfermera requiere la atención del médico, si este no lo atiende inmediatamente le hace una nota y se la deja en el consultorio para que esta resuelva su pedido en el momento que pueda (el pedido puede ser que el médico le firme algún papel). Cuando la petición ha sido recibida por el médico o la nota ha sido dejada en el escritorio, continúa trabajando y haciendo más peticiones.

-- El médico atiende los pedidos dándoles prioridad a los enfermos que llegan para ser atendidos. Cuando atiende un pedido, recibe la solicitud y la procesa durante un cierto tiempo. Cuando está libre aprovecha a procesar las notas dejadas por las enfermeras.


Procedure Clinica is
	Task Medico is
		entry pedido(datos: IN string; diagnostico: OUT string); 
		entry atencion(mensaje: IN/OUT string);
		entry nota(mensaje: IN string);
	End Medico;

	Task Type Paciente;
	Task Type Enfermera;
	Task Intermediario;
	Task Buzon is 
		entry notaIntermediario(dato: OUT boolean);
		entry notaEnfermera(mensaje: IN string);
	End Buzon;

	
	arrPacientes: array(1..P) of Paciente;
	arrEnfermeras: array(1..E) of Enfermera;

	Task Body Medico is 
	Begin
		loop
			select
				accept pedido(datos, diagnostico) is
					resultado := procesar(datos);
				end pedido;
			or
				when (pedido'count = 0) => accept atencion(mensaje) is
					mensaje := analizar(mensaje); -- incluye tiempo de demora de la consulta
				end atencion;
			or
				when (pedido'count = 0 and atencion'count = 0) => accept nota(mensaje) is
					procesarMensaje(mensaje);
				end nota;
			end select;
		end loop;
	End Medico;

	Task Body Paciente is
		strike: integer := 0;
		datos, diagnostico: string;
	Begin
		datos := generarDatos();
		while (strike < 3) loop
			select
				Medico.pedido(datos,diagnostico);
				strike := 3; -- marca de fin de atencion
			or delay 300
				strike := strike +1;
			end select;
			if (strike < 3) then delay 600; -- espera 10 minutos y vuelve a intentar
		end loop;
	End Paciente;

	Task Body Enfermera is
		mensaje, resultado: string;
	Begin
		loop
			trabajar();
			mensaje := generarConsulta();
			select
				Medico.atencion(mensaje);
			else
				-- si el medico no acepta inmediatamente su pedido procede a dejar un mensaje
				-- la enfermera deja la nota, pero nunca aclara que debe recuperar el resultado
				Buzon.notaEnfermera(mensaje);
			end select;
		end loop;
	End Enfermera;

	Task Body Intermediario is
		mensaje: string;
	Begin
		loop
			Buzon.notaIntermediario(dato: OUT string) is
				mensaje := dato;
			end nuevaNota;
			Medico.nota(mensaje);
		end loop;
	End Intermediario;

	Task Body Buzon is
		vector<string> mensajesPendientes;
		mensaje: string;
	Begin
		loop
			select
				accept notaEnfermera(mensaje: IN string) is
					mensajesPendientes.push(mensaje);
				end nota;
			or
				when (mensajesPendientes.size() > 0) => accept notaIntermediario(dato: OUT string) is
					dato := mensajesPendientes.pop();
				end nuevaNota;
			end select;
		end loop;
	End Buzon;


Begin
	null;
End Clinica;
