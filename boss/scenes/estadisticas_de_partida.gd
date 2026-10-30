extends Control

@onready var aciertosText: Label = $PanelContainer3/ContainerButtons/Aciertos
@onready var ganancias: Label = $PanelContainer3/ContainerButtons/Ganancias
@onready var fallos: Label =  $PanelContainer3/ContainerButtons/Fallos

func _ready() -> void:
	var puntos:int = VariablesGlobales.getPuntosTotales();
	aciertosText.text = aciertosText.text + "  " + str(puntos);
	ganancias.text = ganancias.text + "  " + str(int(puntos * 5));
	fallos.text = fallos.text + "  " + str(VariablesGlobales.getFallosTotales());
func _on_volver_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/FinalizarJuego.tscn");
