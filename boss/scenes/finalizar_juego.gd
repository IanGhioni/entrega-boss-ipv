extends Control

@onready var action_sound: AudioStreamPlayer2D = $ActionSound
@onready var hover_sound: AudioStreamPlayer2D = $HoverSound

func _on_play_pressed() -> void:
	action_sound.play(); # elijo creer que cuando estén las transiciones, esto suene
	get_tree().change_scene_to_file("res://scenes/Presentacion.tscn");

func _on_back_menu_button_pressed() -> void:
	action_sound.play();
	get_tree().change_scene_to_file("res://Main.tscn");

func _on_quit_pressed() -> void:
	get_tree().quit();

func _on_mouse_entered() -> void:
	hover_sound.play();
