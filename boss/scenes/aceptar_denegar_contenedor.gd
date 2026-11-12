extends Control
@onready var hover_sound: AudioStreamPlayer2D = $HoverSound;
@onready var action_sound: AudioStreamPlayer2D = $ActionSound;
@onready var aceptar_button: Button = $Container/MarginContainer/ContainerPila/AceptarButton
@onready var rechazar_button: Button = $Container/MarginContainer/ContainerPila/RechazarButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _on_clickear_boton_() -> void:
	action_sound.play();

func _on_mouse_hovereo_boton_() -> void:
	hover_sound.play();

func activarBotones() -> void:
	aceptar_button.disabled = false;
	rechazar_button.disabled = false;
