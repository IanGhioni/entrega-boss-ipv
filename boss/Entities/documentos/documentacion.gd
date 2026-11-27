extends DocumentoBase

@onready var campo_nombre: Label = %CampoNombre
@onready var campo_clase: Label = %CampoClase
@onready var campo_raza: Label = %CampoRaza
@onready var sello: Sprite2D = %Sello
@onready var simbolos := [%Simbolo1, %Simbolo2, %Simbolo3, %Simbolo4, %Simbolo5]
@onready var pase_de_vacaciones: Node2D = $PaseDeVacaciones
@onready var icon_pase_vacaciones: Sprite2D = $PaseDeVacaciones/Icon

const ICONOS_PASES_VALIDOS := "res://assets/documentacion/bajitos/iconosValidos/"
const ICONOS_PASES_INVALIDOS := "res://assets/documentacion/bajitos/iconosInvalidos/"

var clickeado = false
var posicionOriginal: Vector2;
var is_active_expand:bool = false;

func _process(_delta: float) -> void:
	if clickeado:
		var target_pos = get_global_mouse_position()
		var screen_size = get_viewport_rect().size
		var half_size = Vector2(208.0,223.0);
		var min_pos = half_size
		var max_pos = screen_size - half_size
		global_position = target_pos.clamp(min_pos, max_pos)
		position = get_global_mouse_position();
	
func setup(d: DocData) -> void:
	campo_nombre.text = d.nombre
	campo_clase.text = d.clase
	campo_raza.text = d.raza
	sello.texture = load("res://assets/documentacion/sellos/sello%s.png" % d.sello)

	pase_de_vacaciones.visible = (
		d.raza in GeneradorNPC.RAZAS_CON_PASE_VACACIONES
		and d.tiene_pase_vacaciones
	)

	if d.pase_vacaciones_valido:
		icon_pase_vacaciones.texture = obtener_icono_random(ICONOS_PASES_VALIDOS)
	else:
		icon_pase_vacaciones.texture = obtener_icono_random(ICONOS_PASES_INVALIDOS)

	for i in simbolos.size():
		if i < d.simbolos.size():
			simbolos[i].texture = load("res://assets/documentacion/elfos/simbolos/%s.png" % d.simbolos[i])
			simbolos[i].visible = true
		else:
			simbolos[i].visible = false

func _on_area_2d_input_event(_viewport: Node, _event: InputEvent, _shape_idx: int) -> void:
	if Input.is_action_pressed("left_click"):
		clickeado = true;
	if Input.is_action_just_released("left_click"):
		clickeado = false

func _on_expandir_doc_pressed() -> void:
	if not is_active_expand:
		posicionOriginal = position;
		position = Vector2(556.0, 304.0);
		scale = Vector2(1.3,1.3);
	else:
		position = posicionOriginal;
		scale = Vector2.ONE;
	is_active_expand = not is_active_expand;
	

func obtener_icono_random(ruta: String) -> Texture2D:
	var archivos = Array(DirAccess.get_files_at(ruta))
	var pngs = archivos.filter(func(archivo: String):
		return archivo.get_extension().to_lower() == "png"
	)
	
	var archivo_random: String = pngs.get(randi_range(0, pngs.size()-1))
	return load(ruta + archivo_random) as Texture2D
