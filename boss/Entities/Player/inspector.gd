extends CharacterBody2D

var inventario: Array;

var terminoInspeccion: bool = false
var is_dialogue_active:bool = false;
var npcActual;
const Ballon = preload("res://dialogues/balloon.tscn");

@export var preguntar_doc: DialogueResource

@onready var documentacion = $"../../DocumentacionElfica"
@onready var label: Label = $"../../PanelContainer2/Label"
@onready var lista = [$"../../DocumentacionElfica", $"../../Documentacion", $"../../Documentacion2", $"../../DocumentacionElfica2",  $"../../DocumentacionElfica3"]
var counter = 0;

@onready var ask_doc_button: Button = $"../../ButtonsContainer/Container/MarginContainer/ContainerPila/AskDocButton"
@onready var aceptar_button: Button = $"../../ButtonsContainer/Container/MarginContainer/ContainerPila/AceptarButton"
@onready var rechazar_button: Button = $"../../ButtonsContainer/Container/MarginContainer/ContainerPila/RechazarButton"


func _ready() -> void:
	DialogueManager.dialogue_started.connect(_on_ask_doc_button_pressed);
	DialogueManager.dialogue_ended.connect(_on_pressed_decline);
	label.text = "0";
	
	for i in lista:
		i.visible = false;
		
	aceptar_button.disabled = true
	rechazar_button.disabled = true

func _on_pressed_decline(x) -> void:
	if terminoInspeccion:
		terminoInspeccion = false
	else:
		npcActual.visible = true
	var formatString = "%s"
	
	if lista.is_empty():
		ask_doc_button.disabled = true

	label.text = formatString % counter;
	await get_tree().create_timer(0.2).timeout; 
	
func ocultarDocumentacion():
	npcActual.visible = false;

func actualizarContador(botonApretado) -> void:
	if (npcActual.isValid and botonApretado) or (!npcActual.isValid and !botonApretado):
		counter += 1;
	else:
		counter -= 1; 

func _on_aceptar_button_pressed() -> void:
	_accion_de_fila();
	actualizarContador(true);
	DialogueManager.show_dialogue_balloon(preguntar_doc, "aceptar");

func _on_rechazar_button_pressed() -> void:
	_accion_de_fila();
	actualizarContador(false);
	DialogueManager.show_dialogue_balloon(preguntar_doc, "rechazar");

func _accion_de_fila() -> void:
	aceptar_button.disabled = true;
	rechazar_button.disabled = true;
	ask_doc_button.disabled = false;
	terminoInspeccion = true;
	ocultarDocumentacion();

func _on_ask_doc_button_pressed() -> void:
	is_dialogue_active = true;
	aceptar_button.disabled = false;
	rechazar_button.disabled = false;
	ask_doc_button.disabled = true;
	
	npcActual = lista.pop_front();
	print(npcActual.isValid)
	var Ballon: Node = Ballon.instantiate();
	get_tree().current_scene.add_child(Ballon);
	Ballon.start(preguntar_doc,"start");
