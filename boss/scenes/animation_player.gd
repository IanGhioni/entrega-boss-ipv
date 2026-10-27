extends Node2D

@export var personajes_visuales: Array[PackedScene]
@export var escena_npc: PackedScene
@onready var posicion_inicial: Marker2D = $InicioFila
@onready var frente_mesa: Marker2D = $FrenteMesa
@export var distancia_entre_npc: float = 115.0
@onready var entrada: Marker2D = $Entrada
@onready var salida: Marker2D = $Salida

var procesando_fila: bool = false
var fila: Array[Node2D] = []
var npc_actual;


func _ready() -> void:
	if personajes_visuales.is_empty() or escena_npc == null:
		return

	for i in range(personajes_visuales.size()):
		var npc = escena_npc.instantiate()
		add_child(npc)

		npc.global_position = (
			posicion_inicial.global_position
			+ Vector2(distancia_entre_npc * i, 0)
		)

		var visual_elegido = personajes_visuales.pick_random()
		npc.configurar(visual_elegido)

		fila.append(npc)
		print(fila)
		

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

	
	
func dejar_pasar() -> void:
	npc_actual.caminar_hacia(entrada.global_position, 5.0)
	
func no_dejar_pasar() -> void:
	npc_actual.caminar_hacia(salida.global_position, 5.0)
