extends Control

@onready var action_sound: AudioStreamPlayer2D = $ActionSound
@onready var hover_sound: AudioStreamPlayer2D = $HoverSound

func _on_play_pressed() -> void:
	action_sound.play();
	Transicion.cambiar_escena("res://scenes/Presentacion.tscn")
	
func _on_how_to_play_pressed() -> void:
	action_sound.play();
	$ComoJugar.visible = true

func _on_quit_pressed() -> void:
	action_sound.play();
	get_tree().quit();

func _on_mouse_entered() -> void:
	hover_sound.play();
