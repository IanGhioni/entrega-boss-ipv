extends CanvasLayer

func _ready() -> void:
	visible = false
	$CenterContainer/VBoxContainer/Reanudar.pressed.connect(reanudar)
	$CenterContainer/VBoxContainer/Salir.pressed.connect(salir_al_menu)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pausa"):
		alternar_pausa()
		get_viewport().set_input_as_handled()

func alternar_pausa() -> void:
	var pausar := not get_tree().paused
	get_tree().paused = pausar
	visible = pausar

func reanudar() -> void:
	get_tree().paused = false
	visible = false

func salir_al_menu() -> void:
	get_tree().paused = false  # importante: despausar antes de cambiar de escena
	get_tree().change_scene_to_file("res://scenes/menu.tscn")

@onready var hover_sound: AudioStreamPlayer2D = $HoverSound

func _on_mouse_entered() -> void:
	hover_sound.play();
