extends CharacterBody2D

var terminoInspeccion: bool = false
var is_dialogue_active:bool = false;
var npcActual;
var cant_aciertos: int = 0;
var cant_rondas: int = 0;
var max_rondas: int = 5;

const Ballon = preload("res://dialogues/balloon.tscn");

@export var preguntar_doc: DialogueResource

@onready var presentacion: Control = $"../.."
@onready var contador: Label = $"../../ContadorContainer/Contador"
@onready var ask_doc_button: Button = $"../../ButtonsContainer/Container/MarginContainer/ContainerPila/AskDocButton"
@onready var aceptar_button: Button = $"../../ButtonsContainer/Container/MarginContainer/ContainerPila/AceptarButton"
@onready var rechazar_button: Button = $"../../ButtonsContainer/Container/MarginContainer/ContainerPila/RechazarButton"
@onready var fila_animation: Node2D = $"../../FilaAnimationController"

func _ready() -> void:
	
	DialogueManager.dialogue_ended.connect(_on_pressed_decline);
	fila_animation.tamanio = max_rondas;

# Observer de fin de un dialogo
func _on_pressed_decline(_x) -> void:
	if terminoInspeccion:
		terminoInspeccion = false
	elif npcActual != null:
		presentacion.entregar_documentos(npcActual)
	
	if cant_rondas == max_rondas:
		ask_doc_button.disabled = true
		await get_tree().create_timer(0.2).timeout
		get_tree().change_scene_to_file("res://scenes/FinalizarJuego.tscn");
		
func _on_ask_doc_button_pressed() -> void:
	await fila_animation.atender_siguiente()
	fila_animation.mover_fila()
	is_dialogue_active = true;
	aceptar_button.disabled = false;
	rechazar_button.disabled = false;
	ask_doc_button.disabled = true;
	
	# Generamos un nuevo NPC
	npcActual = GeneradorNPC.generar()
	print("Motivo: ", npcActual.motivos)
	
	var Balloon = crear_balloon()
	Balloon.start(preguntar_doc, "start");
	await DialogueManager.dialogue_ended
	fila_animation.dejar_de_hablar_inspector()
	fila_animation.dejar_de_hablar_npc_actual()

func _on_aceptar_button_pressed() -> void:
	_accion_de_fila()

	var balloon = crear_balloon()
	balloon.start(preguntar_doc, "aceptar")

	await DialogueManager.dialogue_ended
	
	fila_animation.dejar_de_hablar_inspector()
	fila_animation.dejar_de_hablar_npc_actual()
	actualizarContador(true)
	fila_animation.dejar_pasar()

func _on_rechazar_button_pressed() -> void:
	_accion_de_fila()

	var balloon = crear_balloon()
	balloon.start(preguntar_doc, "rechazar")

	await DialogueManager.dialogue_ended
	
	fila_animation.dejar_de_hablar_inspector()
	fila_animation.dejar_de_hablar_npc_actual()
	actualizarContador(false)
	fila_animation.no_dejar_pasar()


# Método común entre aceptar/rechazar a alguien
func _accion_de_fila() -> void:
	ask_doc_button.disabled = false;
	aceptar_button.disabled = true;
	rechazar_button.disabled = true;
	terminoInspeccion = true;
	cant_rondas = cant_rondas + 1;
	presentacion.limpiar_mesa()

# Actualiza el contador del nivel por si elegiste correctamente
func actualizarContador(botonApretado) -> void:
	var valido: bool = npcActual.es_valido()
	if (valido and botonApretado) or (!valido and !botonApretado):
		cant_aciertos += 1
	else:
		cant_aciertos -= 1
	contador.text = str(cant_aciertos)

func crear_balloon() -> Node:
	var Balloon: Node = Ballon.instantiate();
	Balloon.fila_animation = fila_animation
	get_tree().current_scene.add_child(Balloon);
	return Balloon
