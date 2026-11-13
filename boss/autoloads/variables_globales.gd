extends Node

@export var puntos_totales:int;
@export var fallos_totales:int;
@export var estaEnTutorial:bool;

func getPuntosTotales() -> int:
	return self.puntos_totales;

func sumarAcierto() -> void:
	puntos_totales = puntos_totales + 1;
	
func sumarFallo()-> void:
	fallos_totales = fallos_totales + 1;

func getFallosTotales() -> int:
	return self.fallos_totales;

func resetarEstadistica() -> void:
	puntos_totales = 0;
	fallos_totales = 0;
