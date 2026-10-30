extends Control

var aciertos:int;

@onready var action_sound: AudioStreamPlayer2D = $ActionSound
@onready var hover_sound: AudioStreamPlayer2D = $HoverSound

func _ready() -> void:
	_calcular_puntaje();

func setUp(cant_aciertos: int) -> void:
	aciertos = cant_aciertos;

func _on_play_pressed() -> void:
	action_sound.play(); # elijo creer que cuando estén las transiciones, esto suene
	Transicion.cambiar_escena("res://scenes/Presentacion.tscn")

func _on_back_menu_button_pressed() -> void:
	action_sound.play();
	Transicion.cambiar_escena("res://Main.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit();

func _on_mouse_entered() -> void:
	hover_sound.play();

@onready var tramitados: Label = $StatsContainer/VBoxContainer2/VBoxContainer/Tramitados
@onready var multas: Label = $StatsContainer/VBoxContainer2/VBoxContainer/Multas
@onready var ganancias: Label = $StatsContainer/VBoxContainer2/Ganancias


func _calcular_puntaje() -> void:
	var cant_validos = VariablesGlobales.getPuntosTotales()
	var cant_ilegales = VariablesGlobales.getFallosTotales()
	
	tramitados.text = tramitados.text + " " + str(cant_validos + cant_ilegales);
	multas.text = multas.text + " " + str(cant_ilegales);

	ganancias.text = ganancias.text + str(cant_validos * 5 - cant_ilegales * 3);
