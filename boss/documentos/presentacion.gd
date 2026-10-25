extends Control

@export var escenas_documentos: Dictionary = {
	"comun": preload("res://documentos/documentacion.tscn"),
}

@onready var mesa_documentos: Node2D = $MesaDocumentos
@onready var puntos: Array[Node] = $Puntos.get_children()

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
