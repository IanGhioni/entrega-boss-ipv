extends Node

var nombreNpcActual: String
var esValido: bool
var motivosPorMostrar: Array[String]
var dataNpcActual: DocData

func actualizarDataNpcActual(npcData: DocData) -> void:
	dataNpcActual = npcData

func esNpcValido() -> bool:
	return motivosPorMostrar.is_empty()

func actualizarNombreNpcDialogo(nombreNpc: String) -> void:
	nombreNpcActual = nombreNpc

func getNombreNpcActual() -> String:
	return nombreNpcActual

func actualizarMotivos(motivos: Array[String]) -> void:
	motivosPorMostrar = motivos

func getMotivos() -> Array[String]:
	return motivosPorMostrar

func mostrarMotivos() -> String:
	if motivosPorMostrar.size() == 3:
		return "1: " + motivosPorMostrar[0] + "  2: " + motivosPorMostrar[1] + "  3: " + motivosPorMostrar[2]
	elif motivosPorMostrar.size() == 2:
		return "1: " + motivosPorMostrar[0] + "  2: " + motivosPorMostrar[1]
	elif motivosPorMostrar.size() == 1:
		return "Única regla incumplida: " + motivosPorMostrar[0]
	else:
		return "Estaba todo en regla."

func respuestaDeTipo_(decisionTexto: String) -> String:
	var raza = dataNpcActual.raza
	var clase = dataNpcActual.clase
	var es_legal = self.esNpcValido()

	match decisionTexto:
		"Aceptar":
			if not es_legal:
				return _generar_falso_positivo(raza, clase)
			else:
				return _generar_verdadero_positivo(raza, clase) 

		"Rechazar":
			if not es_legal:
				return _generar_verdadero_negativo(raza, clase) 
			else:
				return _generar_falso_negativo(raza, clase) 
	return ""; # No deberia pasar...

func _generar_falso_positivo(raza: String, clase: String) -> String:
	var respuestas = [
		"¡Joya, maestro! Sabía que pasaba como piña. ¡Nos re vimos!",
		"¿Posta me dejás pasar? Digo... ¡Obvio, rey! Un abrazo.",
		"Qué pillo que soy, pasé de una. Se nota que no miraste bien mis papeles de " + clase + "...",
		"¡Zarpado! Y eso que pensé que me ibas a rebotar por ser " + raza + ". ¡Chau loco!"
	]
	return respuestas[randi() % respuestas.size()]

func _generar_verdadero_positivo(raza: String, clase: String) -> String:
	var respuestas = [
		"Se agradece, fiera. Todo legal como corresponde.",
		"Y sí capo, los " + raza + " somos de los buenos. Nos vemos.",
		"De una, todo piola. Un buen " + clase + " nunca anda en cosas raras.",
        "Espectacular, inspector. Nos estamos viendo por Berazachusetts."
	]
	return respuestas[randi() % respuestas.size()]

func _generar_verdadero_negativo(raza: String, clase: String) -> String:
	var respuestas = [
		"Uhhh, me re cabió. Bueno me voy, hasta luego.",
		"Haceme la gamba, soy un pobre " + clase + " laburante...",
		"Ya fue, me las tomo. Encima que soy " + raza + " me hacés esta secuencia. Qué ortiva loco.",
        "Uh, me descubriste. Bueno me tomo el palo nomas. Adios."
	]
	return respuestas[randi() % respuestas.size()]

func _generar_falso_negativo(raza: String, clase: String) -> String:
	var respuestas = [
		"¡Pará un cacho! ¿Qué me rebotás si tengo todo en regla? ¡Fijate bien, la proxima...!",
		"¿Cualquiera me mandás? ¡Soy un " + clase + " de primera, mirá bien los papeles, gil!",
		"Che, me parece que estás re ciego. ¡Revisá de nuevo, te juro por los " + raza + " que está todo legal!",
        "¡No te la puedo creer! Te traje todo perfecto, ¿qué queres que te invente, flaco?"
	]
	return respuestas[randi() % respuestas.size()]
