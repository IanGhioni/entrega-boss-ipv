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
##
#func verificar_regla(simbolos: Array):
	#var simbolosPares;
	#simbolosPares = simbolos.filter(_esPar);
	#if simbolosPares.count() == 3:
		#pass
		#
#func _esPar(numero: int):
	#return numero % 2 == 0;
##
