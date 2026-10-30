extends Control

var aciertos:int;

func setUp(cant_aciertos:int) -> void:
	print(cant_aciertos)
	aciertos = cant_aciertos;
	
func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Presentacion.tscn");

func _on_back_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Main.tscn");

func _on_quit_pressed() -> void:
	get_tree().quit();

func _on_match_stats_pressed() -> void:
	await get_tree().create_timer(0.9).timeout;
	var estadisticaPartidaScene: Control = load("res://scenes/EstadisticasDePartida.tscn").instantiate();
	estadisticaPartidaScene.setUp(aciertos);
	get_tree().change_scene_to_file(estadisticaPartidaScene.scene_file_path);
