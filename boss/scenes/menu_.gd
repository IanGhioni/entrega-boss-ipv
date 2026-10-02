extends Control

@export var dialogo_inicial: DialogueResource

func _on_doc_pressed() -> void:
	DialogueManager.show_dialogue_balloon(dialogo_inicial,"start");
