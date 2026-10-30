extends CanvasLayer

const PROGRESO_TAPADO := 0.0
const PROGRESO_LIBRE := 27.0
var _activa := false

@onready var rect: ColorRect = $ColorRect

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
	rect.material.set_shader_parameter("progress", PROGRESO_LIBRE)
	rect.show()

	await _animar(PROGRESO_LIBRE, PROGRESO_TAPADO, duracion)

	get_tree().change_scene_to_file(ruta)
	await get_tree().process_frame
	await get_tree().process_frame

	await _animar(PROGRESO_TAPADO, PROGRESO_LIBRE, duracion)

	rect.hide()
	rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_activa = false

func _animar(desde: float, hasta: float, duracion: float) -> void:
	rect.material.set_shader_parameter("progress", desde)
	var tween := create_tween()
	tween.tween_property(rect.material, "shader_parameter/progress", hasta, duracion)
	await tween.finished
