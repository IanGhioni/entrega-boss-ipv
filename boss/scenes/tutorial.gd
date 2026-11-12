extends Control

@onready var instruccion: Control = $TutorialLayout/Control/ColorRect/Instruccion
@onready var tutorial_layout: CanvasLayer = $TutorialLayout
@onready var campana_container: Control = $CampanaContainer
@onready var aceptar_denegar_container: Control = $AceptarDenegarContainer

# Animaciones
@onready var bell_animation: AnimationPlayer = $BellAnimation
@onready var fila_animation_controller: Node2D = $FilaAnimationController

const Ballon = preload("res://dialogues/balloon.tscn");
var is_dialogue_active: bool = false;
var npcActual;
var globo_actual: Node = null

@export var tutorial_dialogo: DialogueResource

var fase_tutorial: int = 0; 
# Variable que vamos a usar para ordenar las escenas de tutorial. 
# Usandolo como índice para los dialogos.

var titulos_list: Array = [
	"¡Bienvenidos guardias!",
	"Primeros pasos",
	"¡Que pase el siguiente!",
	"Revisar documentos",
	"Revisar documentos",
]

var descripcion_list: Array = [
	"Ahora trabajan cuidando la entrada al reino con tu compañero",
	"Aprederán lo básico para trabajar acá",
	"Toca la campana para llamar a los siguientes fronterizos",
	"Ahora los visitantes te darán los papeles correspondiente.",
	"Consultá con tu compañero como averiguar si son legales",
]

func _ready() -> void:
	if descripcion_list.size() != titulos_list.size():
		push_error("Las descripciones y los titulos no están 1:1")
	
	_actualizar_cuadro_tutorial();

func _on_campana_container_se_activo_campana() -> void:
	campana_container.desabilitarBoton();
	bell_animation.play("bell-pressed")
	await get_tree().create_timer(2.5).timeout
	bell_animation.play("RESET")
	
	_aumentar_fase();
	_actualizar_cuadro_tutorial()
	_mostrar_pantalla_tutorial();
	
	aceptar_denegar_container.show();
	
	if fase_tutorial == 4: # <-- acá el número de fase para el primer
		npcActual = GeneradorNPC.generarValido();
	else:
		npcActual = GeneradorNPC.generarInvalido();
	
	GameManager.voz_npc_actual = null
	GameManager.actualizarDataNpcActual(npcActual.docs[0]);
	GameManager.actualizarNombreNpcDialogo(npcActual.docs[0].nombre);
	GameManager.actualizarMotivos(npcActual.motivos);
	GameManager.actualizarRetratoNpc(GameManager.retratoAleatorio())
	
	is_dialogue_active = true;
	var Balloon = crear_balloon()
	Balloon.start(tutorial_dialogo, "start");
	
	await DialogueManager.dialogue_ended
	fila_animation_controller.dejar_de_hablar_inspector()
	fila_animation_controller.dejar_de_hablar_npc_actual()
	campana_container.mouse_default_cursor_shape = Control.CURSOR_ARROW;
	 

func crear_balloon() -> Node:
	if is_instance_valid(globo_actual):
		globo_actual.queue_free()
		
	var Balloon: Node = Ballon.instantiate();
	Balloon.fila_animation = fila_animation_controller
	get_tree().current_scene.add_child(Balloon);
	
	# Guardamos la referencia para poder acceder a ella después
	globo_actual = Balloon 
	
	return Balloon

func _mostrar_pantalla_tutorial() -> void:
	tutorial_layout.show();

func _aumentar_fase() -> void:
	fase_tutorial += 1;
	
	# La lista son los índice de las instrucciones 
	# que son inicio de ese dialogo de instrucciones
	if fase_tutorial in [3]:
		instruccion.cambiarBtn();

func _actualizar_cuadro_tutorial() -> void:
	instruccion.setTitulo(titulos_list[fase_tutorial]);
	instruccion.setInstruccion(descripcion_list[fase_tutorial]);

func _on_instruccion_siguiente_btn() -> void:
	_aumentar_fase();
	_actualizar_cuadro_tutorial();
	
	# La lista son los índice de las instrucciones 
	# que son finales de ese dialogo
	if fase_tutorial in [2, 4]: 
		instruccion.cambiarBtn();
