extends Node2D

@export var nombre: String;
@export var clase: String;
@export var raza: String;
@export var sello: Texture2D
var isValid: bool = true;

func _ready() -> void:
	$CampoNombre.text = nombre;
	$CampoClase.text = clase;
	$CampoRaza.text = raza;
	$Sello.texture = sello;


func _process(delta: float) -> void:
	pass
	
	
