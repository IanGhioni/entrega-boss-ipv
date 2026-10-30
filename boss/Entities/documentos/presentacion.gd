extends Control

@export var escenas_documentos: Dictionary = {
	"comun": preload("res://Entities/documentos/documentacion.tscn"),
}
@export var time_level: int; 

@onready var mesa_documentos: Node2D = $MesaDocumentos
@onready var puntos: Array[Node] = $Puntos.get_children()
@onready var label: Label = $Timer/TextTimer
@onready var timer: Timer = $Timer

@onready var siguiente: Button = $ContainerSiguienteButton/PanelContainer/Siguiente


func _ready() -> void:
	timer.start(time_level)
	_conectar_botones(self)

	
func _process(_delta: float) -> void:
	label.text = str(int(timer.time_left))

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
	get_tree().change_scene_to_file("res://scenes/FinalizarJuego.tscn");


# Bug con el botón de "llamar siguiente"
# porque reconoce que es otro botón, entonces tiene hover
# :'(

@onready var hover_sound: AudioStreamPlayer2D = $ButtonsContainer/HoverSound

func _conectar_botones(nodo: Node) -> void:
	for hijo in nodo.get_children():
		if hijo is BaseButton:
			hijo.mouse_entered.connect(hover_sound.play)
		_conectar_botones(hijo)
