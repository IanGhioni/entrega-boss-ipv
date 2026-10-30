extends CanvasLayer
@export var documentacion: DocumentoBase
@onready var docActual: DocumentoBase

func _ready() -> void:
	pass
	
func setUp(documento) ->void:
	docActual = documento;
	
	
	
func _enfocar() -> void:
	visible = true
	
func _desenfocar() -> void:
	visible = false
	
