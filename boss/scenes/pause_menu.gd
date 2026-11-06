extends CanvasLayer

@onready var action_sound: AudioStreamPlayer2D = $ActionSound
@onready var hover_sound: AudioStreamPlayer2D = $HoverSound
@onready var pause_sound: AudioStreamPlayer2D = $PauseSound
@onready var opciones_container: PanelContainer = $OpcionesContainer

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

func _on_opciones_pressed() -> void:
	action_sound.play();
	opciones_container.visible = not opciones_container.visible

func salir_al_menu() -> void:
	action_sound.play();
	get_tree().paused = false
	Transicion.cambiar_escena("res://scenes/menu.tscn")

func _on_mouse_entered() -> void:
	hover_sound.play();

func _on_volumn_value_changed(value: float) -> void:
	var multiplicador := value * 2.0
	AudioServer.set_bus_volume_db(0, linear_to_db(multiplicador))
