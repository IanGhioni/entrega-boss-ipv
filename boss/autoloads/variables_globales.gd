extends Node

@export var puntos_totales:int;
@export var fallos_totales:int;

func getPuntosTotales() -> int:
	return self.puntos_totales;

func sumarAcierto() -> void:
	puntos_totales = puntos_totales + 1;
	
func sumarFallo()-> void:
	fallos_totales = fallos_totales + 1;

func getFallosTotales() -> int:
	return self.fallos_totales;
