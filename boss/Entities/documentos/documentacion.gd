extends DocumentoBase

@onready var campo_nombre: Label = %CampoNombre
@onready var campo_clase: Label = %CampoClase
@onready var campo_raza: Label = %CampoRaza
@onready var sello: Sprite2D = %Sello
@onready var simbolos := [%Simbolo1, %Simbolo2, %Simbolo3, %Simbolo4, %Simbolo5]

func setup(d: DocData) -> void:
	campo_nombre.text = d.nombre
	campo_clase.text = d.clase
	campo_raza.text = d.raza
	sello.texture = load("res://assets/documentacion/sellos/sello%s.png" % d.sello)

	for i in simbolos.size():
		if i < d.simbolos.size():
			simbolos[i].texture = load("res://assets/documentacion/elfos/simbolos/%s.png" % d.simbolos[i])
			simbolos[i].visible = true
		else:
			simbolos[i].visible = false
