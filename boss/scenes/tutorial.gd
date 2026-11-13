extends Control

@onready var instruccion: Control = $TutorialLayout/Control/ColorRect/Instruccion
@onready var tutorial_layout: CanvasLayer = $TutorialLayout
@onready var campana_container: Control = $CampanaContainer
@onready var aceptar_denegar_container: Control = $AceptarDenegarContainer
@onready var inspector: CharacterBody2D = $Personajes/Inspector

@export var escenas_documentos: Dictionary = {
	"comun": preload("res://Entities/documentos/documentacion.tscn"),
}

@onready var mesa_documentos: Node2D = $MesaDocumentos;
@onready var puntos: Array[Node] = $Puntos.get_children();

# Animaciones
@onready var bell_animation: AnimationPlayer = $BellAnimation
@onready var fila_animation_controller: Node2D = $FilaAnimationController

const Ballon = preload("res://dialogues/balloon.tscn");
var is_dialogue_active: bool = false;
var npcActual;
var globo_actual: Node = null

@export var tutorial_dialogo: DialogueResource

var terminoFase: bool = false;
var fase_tutorial: int = 0; 
# Variable que vamos a usar para ordenar las escenas de tutorial. 
# Usandolo como índice para los dialogos.
var faseConCantidadDeIndicaciones: Dictionary[int,int] = {
	0: 2,
	1: 1,
	2: 2
}
var titulosFase0: Array = [
	"¡Bienvenidos guardias!",
	"Primeros pasos",
	"¡Que pase el siguiente!",
]

var titulosFase1: Array = [
	"Revisar documentos",
	"Revisar documentos",
]
#var titulosFase2: Array = [""]
var titulos_list: Array = [titulosFase0,titulosFase1]

var descripcionFase0: Array = [
	"Empezamos trabajando cuidando la entrada al reino con tu compañero",
	"Aprederán lo básico para trabajar acá",
	"Tocá la campana para llamar a los siguientes visitantes",
]
var descripcionFase1: Array = [
	"Los visitantes te darán un Documento para que lo analices.",
	"Consultá con tu compañero. Averigua si son legales",
]
var descripcion_list: Array = [descripcionFase0,descripcionFase1];

func _ready() -> void:
	if descripcion_list.size() != titulos_list.size():
		push_error("Las descripciones y los titulos no están 1:1")
	#Para el map asi los puede ir contando...
	   #Al instanciar seguimos el orden. En la implementacion va al reves.
	reordenarParaMap();
	_actualizar_cuadro_tutorial();

#La fase 3 es cuando le da aceptar o rechazar.
#La fase 4 es cuando termino el juego.
func reordenarParaMap():
	titulosFase0.reverse();
	titulosFase1.reverse();
	descripcionFase0.reverse();
	descripcionFase1.reverse();
#Campana seria Fase 2
func _on_campana_container_se_activo_campana() -> void:
	campana_container.desabilitarBoton();
	bell_animation.play("bell-pressed")
	await get_tree().create_timer(2.5).timeout
	bell_animation.play("RESET")
	
	_actualizar_cuadro_tutorial()
	_mostrar_pantalla_tutorial();
	
	# Se decide acá, ANTES del await (ver nota abajo)
	if faseConCantidadDeIndicaciones.get(fase_tutorial) == 3:
		npcActual = GeneradorNPC.generarValido();
	elif faseConCantidadDeIndicaciones.get(fase_tutorial) == 2:
			#Generar uno sin runas)?
			npcActual = GeneradorNPC.generarInvalido();
	else:
			#Generar uno con runas)?
			npcActual = GeneradorNPC.generarInvalido(); 
	
	inspector.setNPCActual(npcActual);
	
	GameManager.voz_npc_actual = null
	GameManager.actualizarDataNpcActual(npcActual.docs[0]);
	GameManager.actualizarNombreNpcDialogo(npcActual.docs[0].nombre);
	GameManager.actualizarMotivos(npcActual.motivos);
	GameManager.actualizarRetratoNpc(GameManager.retratoAleatorio())
	
	# Recién cuando el jugador cierra el tutorial arranca el diálogo
	await _esperar_cierre_tutorial()
	
	aceptar_denegar_container.show();
	is_dialogue_active = true;
	var Balloon = crear_balloon()
	Balloon.start(tutorial_dialogo, "start");
	
	await DialogueManager.dialogue_ended
	fila_animation_controller.dejar_de_hablar_inspector()
	fila_animation_controller.dejar_de_hablar_npc_actual()
	
	aceptar_denegar_container.activarBotones();
	self.entregar_documentos(npcActual)

func _esperar_cierre_tutorial() -> void:
	while tutorial_layout.visible:
		await tutorial_layout.visibility_changed

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

func _actualizar_cuadro_tutorial() -> void:
	instruccion.setTitulo(titulos_list[fase_tutorial][faseConCantidadDeIndicaciones.get(fase_tutorial)]);
	instruccion.setInstruccion(descripcion_list[fase_tutorial][faseConCantidadDeIndicaciones.get(fase_tutorial)]);

func _on_instruccion_siguiente_btn() -> void:
	_actualizar_cuadro_tutorial();
	faseConCantidadDeIndicaciones.set(
		fase_tutorial,
		faseConCantidadDeIndicaciones.get(fase_tutorial) - 1
	)
	# La lista son los índice de las instrucciones 
	# que son finales de ese dialogo
	if faseConCantidadDeIndicaciones.get(fase_tutorial) == 0:
		instruccion.cambiarBtn();

func entregar_documentos(npc: NPCData) -> void:
	limpiar_mesa()
	for i in npc.docs.size():
		var doc: DocumentoBase = escenas_documentos[npc.docs[i].tipo].instantiate()
		mesa_documentos.add_child(doc)
		doc.setup(npc.docs[i])
		doc.global_position = _posicion_libre(i)

func limpiar_mesa() -> void:
	for hijo in mesa_documentos.get_children():
		hijo.queue_free()

func _posicion_libre(indice: int) -> Vector2:
	return puntos[indice % puntos.size()].position

func _on_instruccion_cerrar_btn() -> void:
	_aumentar_fase();
