extends Control

var aciertos:int;

@onready var action_sound: AudioStreamPlayer2D = $ActionSound
@onready var hover_sound: AudioStreamPlayer2D = $HoverSound

func setUp(cant_aciertos:int) -> void:
	aciertos = cant_aciertos;
	
func _on_play_pressed() -> void:
	action_sound.play(); # elijo creer que cuando estén las transiciones, esto suene
	Transicion.cambiar_escena("res://scenes/Presentacion.tscn")

func _on_back_menu_button_pressed() -> void:
	action_sound.play();
	Transicion.cambiar_escena("res://Main.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit();

func _on_match_stats_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/EstadisticasDePartida.tscn");

func _on_mouse_entered() -> void:
	hover_sound.play();
