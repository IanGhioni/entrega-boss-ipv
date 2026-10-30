extends DocumentoBase

@onready var campo_nombre: Label = %CampoNombre
@onready var campo_clase: Label = %CampoClase
@onready var campo_raza: Label = %CampoRaza
@onready var sello: Sprite2D = %Sello
@onready var simbolos := [%Simbolo1, %Simbolo2, %Simbolo3, %Simbolo4, %Simbolo5]
var clickeado = false
var posicionOriginal: Vector2;
var is_active_expand:bool = false;

func _process(delta: float) -> void:
	if clickeado:
		position = get_global_mouse_position();

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

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if Input.is_action_pressed("left_click"):
		clickeado = true;
	if Input.is_action_just_released("left_click"):
		clickeado = false

func _on_expandir_doc_pressed() -> void:
	if not is_active_expand:
		posicionOriginal = position;
		position = Vector2(556.0, 304.0);
		scale = Vector2(1.4,1.7);
	else:
		position = posicionOriginal;
		scale = Vector2.ONE;
	is_active_expand = not is_active_expand;
		 
