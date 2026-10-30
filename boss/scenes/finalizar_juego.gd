extends Control

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Presentacion.tscn");

func _on_back_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Main.tscn");

func _on_quit_pressed() -> void:
	get_tree().quit();

@onready var hover_sound: AudioStreamPlayer2D = $HoverSound

func _on_mouse_entered() -> void:
	hover_sound.play();
