extends CharacterBody2D

var inventario: Array;

var terminoInspeccion: bool = false
var is_dialogue_active:bool = false;
var npcActual;
@export var preguntar_doc: DialogueResource
@onready var documentacion = $"../../DocumentacionElfica"
@onready var aceptar = $"../../Aceptar"
@onready var rechazar = $"../../Rechazar"
@onready var label: Label = $"../../PanelContainer2/Label"
@onready var lista = [$"../../DocumentacionElfica", $"../../Documentacion", $"../../Documentacion2", $"../../DocumentacionElfica2",  $"../../DocumentacionElfica3"]
var counter = 0;

func _ready() -> void:
	DialogueManager.dialogue_started.connect(_on_preguntar_doc_pressed);
	DialogueManager.dialogue_ended.connect(_on_pressed_decline);
	label.text = "0";
	
	for i in lista:
		i.visible = false;
		
	aceptar.visible = false
	rechazar.visible = false

func _on_pressed_decline(x) -> void:
	if terminoInspeccion:
		terminoInspeccion = false
	else:
		npcActual.visible = true
	var formatString = "%s"
	label.text = formatString % counter;
	await get_tree().create_timer(0.2).timeout; 

func _on_preguntar_doc_pressed() -> void:
	is_dialogue_active = true;
	aceptar.visible = true;
	rechazar.visible = true;
	npcActual = lista.pop_front();
	print(npcActual.isValid)
	DialogueManager.show_dialogue_balloon(preguntar_doc,"start");
	
func ocultarDocumentacion():
	npcActual.visible = false;

func _on_aceptar_pressed() -> void:
	aceptar.visible = false;
	rechazar.visible = false;
	terminoInspeccion = true;
	ocultarDocumentacion();
	actualizarContador(true);

	DialogueManager.show_dialogue_balloon(preguntar_doc, "aceptar");


func _on_rechazar_pressed() -> void:
	aceptar.visible = false;
	rechazar.visible = false;
	terminoInspeccion = true;
	ocultarDocumentacion();
	actualizarContador(false);
	DialogueManager.show_dialogue_balloon(preguntar_doc, "rechazar");

func actualizarContador(botonApretado) -> void:
	if (npcActual.isValid and botonApretado) or (!npcActual.isValid and !botonApretado):
		counter += 1;
	else:
		counter -= 1; 
