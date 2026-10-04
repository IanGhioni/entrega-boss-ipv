extends Node

var simbolos: Array;
func _ready() -> void:
	randomize();
	generar_simbolos();

func generar_simbolos():
	var i: int = 0;
	while i < 5:
		simbolos.push_back(randi_range(0, 1));
		i= i + 1;
