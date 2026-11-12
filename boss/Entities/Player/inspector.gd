extends CharacterBody2D

const Ballon = preload("res://dialogues/balloon.tscn");
var terminoInspeccion: bool = false
var is_dialogue_active: bool = false;
var npcActual;
var cant_aciertos: int = 0;
var cant_rondas: int = 0;
var globo_actual: Node = null

@export var max_rondas: int;
@export var preguntar_doc: DialogueResource

#Nodo raiz

@onready var presentacion: Control = $"../../"

# Container Campana y Botones
@onready var campanaContainer: Control = $"../../CampanaContainer"
@onready var aceptar_denegar_container: Control = $"../../AceptarDenegarContainer"

# Container Multa
@onready var multa_container: Control = $"../../Multa"

# Animaciones
@onready var bell_animation: AnimationPlayer = $"../../BellAnimation"
@onready var fila_animation: Node2D = $"../../FilaAnimationController"
@onready var animación_de_multa: AnimationPlayer = $"../../AnimaciónDeMulta"


func _ready() -> void:
	DialogueManager.dialogue_ended.connect(_on_pressed_decline);
	fila_animation.tamanio = max_rondas;
	
func eliminar_dialogo() -> void:
	if is_instance_valid(globo_actual):
		globo_actual.queue_free()
		globo_actual = null

# Observer de fin de un dialogo
func _on_pressed_decline(_x) -> void:
	if terminoInspeccion:
		terminoInspeccion = false
		aceptar_denegar_container.hide();
	elif npcActual != null:
		presentacion.entregar_documentos(npcActual)
		#Boton aceptar
		aceptar_denegar_container.activarBotones();
	
	if cant_rondas == max_rondas:
		campanaContainer.disabled = true
		await get_tree().create_timer(5.0).timeout
		Transicion.cambiar_escena("res://scenes/FinalizarJuego.tscn")

func _on_ask_doc_button_pressed() -> void:
	bell_animation.play("bell-pressed")
	campanaContainer.desabilitarBoton();
	await fila_animation.atender_siguiente()
	fila_animation.mover_fila()
	is_dialogue_active = true;
	aceptar_denegar_container.show();
	
	# Generamos un nuevo NPC
	npcActual = GeneradorNPC.generar()
	GameManager.voz_npc_actual = null
	print("Motivo: ", npcActual.motivos)
	
	GameManager.actualizarDataNpcActual(npcActual.docs[0]);
	GameManager.actualizarNombreNpcDialogo(npcActual.docs[0].nombre);
	GameManager.actualizarMotivos(npcActual.motivos);
	GameManager.actualizarRetratoNpc(GameManager.retratoAleatorio())
	
	var Balloon = crear_balloon()
	Balloon.start(preguntar_doc, "start");
	
	await DialogueManager.dialogue_ended
	fila_animation.dejar_de_hablar_inspector()
	fila_animation.dejar_de_hablar_npc_actual()
	campanaContainer.mouse_default_cursor_shape = Control.CURSOR_ARROW;
	
func _on_aceptar_button_pressed() -> void:
	_accion_de_fila()
	
	var balloon = crear_balloon()
	balloon.start(preguntar_doc, "aceptar")
	
	await DialogueManager.dialogue_ended
	GameManager.actualizarMotivos([]);
	fila_animation.dejar_de_hablar_inspector()
	fila_animation.dejar_de_hablar_npc_actual()
	actualizar_multa(true)
	actualizarContador(true)
	bell_animation.play("bell-idle-alternate")
	fila_animation.dejar_pasar()
	campanaContainer.desactivarDeteccionMouse();

func _on_rechazar_button_pressed() -> void:
	_accion_de_fila()

	var balloon = crear_balloon()
	balloon.start(preguntar_doc, "rechazar")
	await DialogueManager.dialogue_ended
	
	fila_animation.dejar_de_hablar_inspector()
	fila_animation.dejar_de_hablar_npc_actual()
	actualizar_multa(false)
	actualizarContador(false)
	bell_animation.play("bell-idle-alternate")
	fila_animation.no_dejar_pasar()
	campanaContainer.activarDeteccionMouse();

# Método común entre aceptar/rechazar a alguien
func _accion_de_fila() -> void:
	campanaContainer.disabled = false;
	aceptar_denegar_container.disabled = true;
	terminoInspeccion = true;
	cant_rondas = cant_rondas + 1;
	presentacion.limpiar_mesa()

func actualizarContador(botonApretado) -> void:
	var valido: bool = npcActual.es_valido()
	if (valido and botonApretado) or (!valido and !botonApretado):
		VariablesGlobales.sumarAcierto();
		cant_aciertos += 1
	else:
		VariablesGlobales.sumarFallo();
		cant_aciertos -= 1
	#contador.text = str(cant_aciertos)

func crear_balloon() -> Node:
	if is_instance_valid(globo_actual):
		globo_actual.queue_free()
		
	var Balloon: Node = Ballon.instantiate();
	Balloon.fila_animation = fila_animation
	get_tree().current_scene.add_child(Balloon);
	
	# Guardamos la referencia para poder acceder a ella después
	globo_actual = Balloon 
	
	return Balloon
	
func actualizar_multa(dejo_pasar: bool) -> void:
	var valido: bool = npcActual.es_valido()
	var textoMullta: Label = multa_container.get_child(2).get_child(0).get_child(0);
	if (valido and dejo_pasar) or (!valido and !dejo_pasar):
		textoMullta.text = ""
		return

	if dejo_pasar:
		textoMullta.text = npcActual.obtener_motivos_string()
	else:
		textoMullta.text = "Ciudadano con documentación valida"
	animación_de_multa.play("mostar_multa")
