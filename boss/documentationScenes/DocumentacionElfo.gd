extends Node2D

@export var nombre: String
@export var clase: String
@onready var simbolo_1: Sprite2D = $Simbolo1
@onready var simbolo_2: Sprite2D = $Simbolo2
@onready var simbolo_3: Sprite2D = $Simbolo3
@onready var simbolo_4: Sprite2D = $Simbolo4
@onready var simbolo_5: Sprite2D = $Simbolo5
var isValid: bool

func _ready() -> void:
	$Documentacion/CampoNombre.text = nombre
	$Documentacion/CampoClase.text = clase
	
	
	var my_random_number = randf_range(0., 11.0)
	if (my_random_number > 3):
		generarCadenaValida();
		isValid = true;
	else:
		generarCadenaAleatoria();
		isValid = false;

func generarCadenaValida():
	var ls = [simbolo_1, simbolo_2, simbolo_3, simbolo_4, simbolo_5];
	var formatString = "res://assets/documentación/elFos/simbolos/%s.png"
	for n in range(1,6):
		var imagen: Texture2D;
		ls.get(n-1).texture = load(formatString % n);

func generarCadenaAleatoria():
	var ls = [simbolo_1, simbolo_2, simbolo_3, simbolo_4, simbolo_5];
	var formatString = "res://assets/documentación/elFos/simbolos/%s.png"
	for n in range(1,6):
		var imagen: Texture2D;
		
		ls.get(n-1).texture = load(formatString % randi_range(1,17));
	#nuevamente, parseando bien xd
	#rand entre 1 a 17

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
