extends Control


func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Presentacion.tscn");

func _on_how_to_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ComoJugar.tscn");

func _on_quit_pressed() -> void:
	get_tree().quit();
