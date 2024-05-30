-- Problema: En una clínica existe un médico de guardia que recibe continuamente peticiones de atención de las E enfermeras que trabajan en su piso y de las P personas que llegan a la clínica ser atendidos. 

-- Cuando una persona necesita que la atiendan espera a lo sumo 5 minutos a que el médico lo haga, si pasado ese tiempo no lo hace, espera 10 minutos y vuelve a requerir la atención del médico. Si no es atendida tres veces, se enoja y se retira de la clínica.

-- Cuando una enfermera requiere la atención del médico, si este no lo atiende inmediatamente le hace una nota y se la deja en el consultorio para que esta resuelva su pedido en el momento que pueda (el pedido puede ser que el médico le firme algún papel). Cuando la petición ha sido recibida por el médico o la nota ha sido dejada en el escritorio, continúa trabajando y haciendo más peticiones.

-- El médico atiende los pedidos dándoles prioridad a los enfermos que llegan para ser atendidos. Cuando atiende un pedido, recibe la solicitud y la procesa durante un cierto tiempo. Cuando está libre aprovecha a procesar las notas dejadas por las enfermeras.


Procedure Clinica is
	Task Medico is
		entry pedido(datos: IN string; diagnostico: OUT string); 
		entry atencion(mensaje: IN/OUT string);
		entry nota(mensaje: IN string; resultado: OUT string);
	End Medico;

	Task Type Paciente;
	Task Type Enfermera;
	
	arrPacientes: array(1..P) of Paciente;
	arrEnfermeras: array(1..E) of Enfermera;

	Task Body Medico is 
	Begin
		loop
			select
				accept pedido(datos, resultado) is
					resultado := procesar(datos);
				end pedido;
			else
				accept atencion(datos) is
					datos := escucharYEmitirRespuesta(datos);
				end atencion;
			else
				accept nota(mensaje,resultado) is
					resultado := procesarMensaje(mensaje);
			end nota;
		end loop;
	End Medico;

	Task Body Paciente is
		datos, diagnostico: string;
	Begin
		datos := generarDatos();
		select
			Medico.pedido(datos,diagnostico);
		or delay 300
			delay 600;
			select Medico.pedido(datos,diagnostico); 
				select Medico.pedido(datos,diagnostico); 
					select Medico.pedido(datos,diagnostico); 
					else retirarse();
				else retirarse();
			else retirarse();
			end select;
		end select;
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
				Medico.nota(mensaje,resultado);
			end select;
		end loop;
	End Enfermera;

Begin
	null;
End Clinica;