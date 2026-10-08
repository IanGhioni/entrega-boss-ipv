extends CharacterBody2D

var inventario: Array;

var is_dialogue_active:bool = false;
@export var preguntar_doc: DialogueResource

func _ready() -> void:
	DialogueManager.dialogue_started.connect(_on_preguntar_doc_pressed);
	DialogueManager.dialogue_ended.connect(_on_pressed_decline);

func _on_pressed_decline() -> void:
	await get_tree().create_timer(0.2).timeout; 
	is_dialogue_active = false

func _on_preguntar_doc_pressed() -> void:
	#Si se presiona el boton "Preguntar doc", arranca el dialogo.
	is_dialogue_active = true;
	DialogueManager.show_dialogue_balloon(preguntar_doc,"start");
