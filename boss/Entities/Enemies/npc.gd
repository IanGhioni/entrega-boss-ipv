extends Area2D

var has_interaction = false;
var is_dialogue_active = false;
@export var dialogo_inicial: DialogueResource

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	DialogueManager.dialogue_started.connect(_on_dialogue_started);
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended);

func _on_dialogue_started(dialogue):
	is_dialogue_active = true;
	
func _on_dialogue_ended(dialogue):
	#Evita que se reproduzca de vuelta el dialogo
	await get_tree().create_timer(0.2).timeout; 
	is_dialogue_active = false
	
func _process(delta: float) -> void:
	if Input.is_action_pressed("ui_accept") and not is_dialogue_active:
		DialogueManager.show_dialogue_balloon(dialogo_inicial,"start");
