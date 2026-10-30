extends CanvasLayer

@onready var action_sound: AudioStreamPlayer2D = $ActionSound
@onready var hover_sound: AudioStreamPlayer2D = $HoverSound
@onready var pause_sound: AudioStreamPlayer2D = $PauseSound

func _ready() -> void:
	visible = false
	$CenterContainer/VBoxContainer/Reanudar.pressed.connect(reanudar)
	$CenterContainer/VBoxContainer/Salir.pressed.connect(salir_al_menu)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pausa"):
		alternar_pausa()
		get_viewport().set_input_as_handled()

func alternar_pausa() -> void:
	pause_sound.play();
	var pausar := not get_tree().paused
	get_tree().paused = pausar
	visible = pausar

func reanudar() -> void:
	action_sound.play();
	get_tree().paused = false
	visible = false

func salir_al_menu() -> void:
	action_sound.play();
	get_tree().paused = false  # importante: despausar antes de cambiar de escena
	get_tree().change_scene_to_file("res://scenes/menu.tscn")

func _on_mouse_entered() -> void:
	hover_sound.play();
