extends CanvasLayer

const PROGRESO_MAX := 27.0

@onready var rect: ColorRect = $ColorRect

func _ready() -> void:
	rect.material.set_shader_parameter("position", Vector2(0.5, 0.5))
	rect.material.set_shader_parameter("grid_size", Vector2(15.0, 15.0))
	rect.material.set_shader_parameter("progress_bias", Vector2(10.0, 10.0))
	rect.hide()

func cambiar_escena(ruta: String, duracion := 1.0) -> void:
	rect.show()
	await _animar(0.0, PROGRESO_MAX, duracion)

	await _animar(PROGRESO_MAX, 0.0, duracion)
	get_tree().change_scene_to_file(ruta)
	await get_tree().process_frame
	await get_tree().process_frame

	rect.hide()

func _animar(desde: float, hasta: float, duracion: float) -> void:
	rect.material.set_shader_parameter("progress", desde)
	var tween := create_tween()
	tween.tween_property(rect.material, "shader_parameter/progress", hasta, duracion)
	await tween.finished
