extends Control

signal aceptar_presionado
signal rechazar_presionado

@onready var hover_sound: AudioStreamPlayer2D = $HoverSound
@onready var action_sound: AudioStreamPlayer2D = $ActionSound
@onready var aceptar_button: Button = $Container/MarginContainer/ContainerPila/AceptarButton
@onready var rechazar_button: Button = $Container/MarginContainer/ContainerPila/RechazarButton

func _ready() -> void:
	aceptar_button.pressed.connect(_on_aceptar_pressed)
	rechazar_button.pressed.connect(_on_rechazar_pressed)

func _on_aceptar_pressed() -> void:
	action_sound.play()
	aceptar_presionado.emit()

func _on_rechazar_pressed() -> void:
	action_sound.play()
	rechazar_presionado.emit()

func _on_clickear_boton_() -> void:
	action_sound.play();

func _on_mouse_hovereo_boton_() -> void:
	hover_sound.play();

func activarBotones() -> void:
	aceptar_button.disabled = false;
	rechazar_button.disabled = false;

func desactivarBotones() -> void:
	aceptar_button.disabled = true;
	rechazar_button.disabled = true;
