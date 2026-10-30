extends Control

@export var escenas_documentos: Dictionary = {
	"comun": preload("res://Entities/documentos/documentacion.tscn"),
}
@export var time_level: int;

@onready var mesa_documentos: Node2D = $MesaDocumentos
@onready var puntos: Array[Node] = $Puntos.get_children()
@onready var timer_label: Label = $Timer/TextTimer
@onready var timer: Timer = $Timer

@onready var siguiente: Button = $ContainerSiguienteButton/PanelContainer/Siguiente

# Sonidos
@onready var hover_sound: AudioStreamPlayer2D = $ButtonsContainer/HoverSound
@onready var tiempo_finalizado: AudioStreamPlayer2D = $Timer/TiempoFinalizado

func _ready() -> void:
	timer.start(time_level)

	
func _process(_delta: float) -> void:
	if not timer.is_stopped():
		timer_label.text = str(int(timer.time_left))

func _posicion_libre(indice: int) -> Vector2:
	return puntos[indice % puntos.size()].position
	
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


func _on_timer_timeout() -> void:
	timer.stop()
	timer_label.text = "Fin del juego"
	tiempo_finalizado.play()
	await get_tree().create_timer(5.0).timeout
	Transicion.cambiar_escena("res://scenes/FinalizarJuego.tscn")

func _on_aceptar_button_mouse_entered() -> void:
	hover_sound.play();


func _on_rechazar_button_mouse_entered() -> void:
	hover_sound.play();
