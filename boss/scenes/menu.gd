extends Control

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Presentacion.tscn");
	#Transicion.cambiar_escena("res://scenes/Presentacion.tscn")
	# Lo dejo comentario por si las dudas se usa después
	# Sino borro

func _on_how_to_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ComoJugar.tscn");

func _on_quit_pressed() -> void:
	get_tree().quit();
