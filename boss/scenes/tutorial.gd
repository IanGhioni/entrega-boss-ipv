extends Control

@onready var instruccion: Control = $TutorialLayout/Control/ColorRect/Instruccion
@onready var tutorial_layout: CanvasLayer = $TutorialLayout

func _on_campana_container_se_activo_campana() -> void:
	await get_tree().create_timer(2.5).timeout
	instruccion.setTitulo("Revisar documentos");
	instruccion.setInstruccion("Consultá con tu compañero como averiguar si son legales");
	tutorial_layout.show();
