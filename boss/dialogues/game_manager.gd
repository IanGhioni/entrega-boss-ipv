extends Node

@export var nombreNpcActual: String;

func actualizarNombreNpcDialogo(nombreNpc: String) -> void:
	nombreNpcActual = nombreNpc;

func getNombreNpcActual() -> String:
	return nombreNpcActual;
