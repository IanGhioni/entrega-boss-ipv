extends Node

var nombreNpcActual: String;
var esValido: bool;
var motivosPorMostrar: Array[String];

func esNpcValido() -> bool:
	return motivosPorMostrar.is_empty();

func actualizarNombreNpcDialogo(nombreNpc: String) -> void:
	nombreNpcActual = nombreNpc;

func getNombreNpcActual() -> String:
	return nombreNpcActual;

func actualizarMotivos(motivos: Array[String]) -> void:
	motivosPorMostrar = motivos;

func getMotivos() -> Array[String]:
	return motivosPorMostrar;

func mostrarMotivos() -> String:
	if motivosPorMostrar.size() == 3:
		return "1: " + motivosPorMostrar[0] + " " + " 2: " + motivosPorMostrar[1] + " /" + " 3: " +motivosPorMostrar[2];
	elif motivosPorMostrar.size() ==  2:
		return "1: " + motivosPorMostrar[0] + " " + " 2: " + motivosPorMostrar[1];
	else: 
		return "Unica regla incumplida: " + motivosPorMostrar[0];
