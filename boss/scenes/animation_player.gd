extends Node2D

@export var personajes_visuales: Array[PackedScene]
@export var escena_npc: PackedScene
@export var tamanio: int = 5

@onready var inspector: AnimatedSprite2D = $InspectorSprite
@onready var posicion_inicial: Marker2D = $InicioFila
@onready var frente_mesa: Marker2D = $FrenteMesa
@onready var entrada: Marker2D = $Entrada
@onready var salida: Marker2D = $Salida

@export var distancia_entre_npc: float = 115.0

var procesando_fila: bool = false
var fila: Array[Node2D] = []
var npc_actual

var sprites_posibles: Array[String] = ["arquero","ballestero","elfo","picaro","enano","mago","magoJoven","mercader","nigromante","paladin"]


func _ready() -> void:
	if escena_npc == null:
		push_error("No se asignó la escena NPC.")
		return

	if tamanio <= 0:
		return

	for i in range(tamanio):
		var npc = escena_npc.instantiate()
		add_child(npc)

		npc.global_position = (posicion_inicial.global_position + Vector2(distancia_entre_npc * i, 0))

		var nombre_sprite = sprites_posibles.pick_random()
		var ruta_sprite = "res://Entities/NPCs/" + nombre_sprite + ".tscn"
		var escena_visual = load(ruta_sprite) as PackedScene

		if escena_visual == null:
			push_error("No se pudo cargar la escena: " + ruta_sprite)
			npc.queue_free()
			continue

		npc.configurar(escena_visual)
		fila.append(npc)


func _process(delta: float) -> void:
	pass
	
func llevar_primero_a_mesa(destino: Marker2D) -> void:
	if fila.is_empty():
		return
	npc_actual = fila.pop_front()
	await npc_actual.caminar_hacia(destino.global_position)

func atender_siguiente() -> void:
	if fila.is_empty() or procesando_fila:
		return

	procesando_fila = true	

	# El NPC avanza hasta la mesa.
	await llevar_primero_a_mesa(frente_mesa)

func mover_fila() -> void:
	# Los demás avanzan un lugar.
	for i in range(fila.size()):
		var destino = (
			posicion_inicial.global_position
			+ Vector2(distancia_entre_npc * i, 0)
		)

		# Iniciamos todos los movimientos simultáneamente.
		fila[i].caminar_hacia(destino,1.0)

	# Esperamos a que termine el desplazamiento de los demás.
	await get_tree().create_timer(1.0).timeout

	procesando_fila = false

func hablar_inspector() -> void:
	inspector.play("talk")

func dejar_de_hablar_inspector() -> void:
	inspector.play("idle")

func dejar_pasar() -> void:
	npc_actual.caminar_hacia(entrada.global_position, 5.0)
	
func no_dejar_pasar() -> void:
	npc_actual.caminar_hacia(salida.global_position, 5.0)
	
func hablar_npc_actual() -> void:
	npc_actual.hablar()

func dejar_de_hablar_npc_actual() -> void:
	npc_actual.dejar_de_hablar()
