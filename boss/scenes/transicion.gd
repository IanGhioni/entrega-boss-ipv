extends CanvasLayer

const PROGRESO_TAPADO := 0.0    # ColorRect 100% negro
const PROGRESO_LIBRE := 27.0    # ColorRect totalmente transparente

@onready var rect: ColorRect = $ColorRect

var _activa := false

func _ready() -> void:
	layer = 100
	process_mode = Node.PROCESS_MODE_ALWAYS
	rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	rect.material.set_shader_parameter("position", Vector2(0.5, 0.5))
	rect.material.set_shader_parameter("grid_size", Vector2(15.0, 15.0))
	rect.material.set_shader_parameter("progress_bias", Vector2(10.0, 10.0))
	rect.material.set_shader_parameter("progress", PROGRESO_LIBRE)
	rect.hide()

func cambiar_escena(ruta: String, duracion := 1.0) -> void:
	if _activa:
		return
	_activa = true
	rect.mouse_filter = Control.MOUSE_FILTER_STOP
	rect.material.set_shader_parameter("progress", PROGRESO_LIBRE)  # empieza transparente
	rect.show()

	await _animar(PROGRESO_LIBRE, PROGRESO_TAPADO, duracion)   # 1) los cuadrados tapan la escena

	get_tree().change_scene_to_file(ruta)                      # 2) cambio con todo negro
	await get_tree().process_frame
	await get_tree().process_frame

	await _animar(PROGRESO_TAPADO, PROGRESO_LIBRE, duracion)   # 3) los cuadrados revelan la nueva

	rect.hide()
	rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_activa = false

func _animar(desde: float, hasta: float, duracion: float) -> void:
	rect.material.set_shader_parameter("progress", desde)
	var tween := create_tween()
	tween.tween_property(rect.material, "shader_parameter/progress", hasta, duracion)
	await tween.finished
