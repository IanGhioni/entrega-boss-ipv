extends Control

@onready var multa_texto: Label = $PanelContainer/VBoxContainer/MultaTexto

func set_texto(texto: String) -> void:
	multa_texto.text = texto

func limpiar() -> void:
	multa_texto.text = ""
	
