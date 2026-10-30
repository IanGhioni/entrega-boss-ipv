extends Control

@onready var action_sound: AudioStreamPlayer2D = $ActionSound
@onready var hover_sound: AudioStreamPlayer2D = $HoverSound

func _on_play_pressed() -> void:
	action_sound.play();
	get_tree().change_scene_to_file("res://scenes/Presentacion.tscn");
	#Transicion.cambiar_escena("res://scenes/Presentacion.tscn")
	# Lo dejo comentario por si las dudas se usa después
	# Sino borro

func _on_how_to_play_pressed() -> void:
	action_sound.play();
	$ComoJugar.visible = true

func _on_quit_pressed() -> void:
	action_sound.play();
	get_tree().quit();

func _on_mouse_entered() -> void:
	hover_sound.play();
