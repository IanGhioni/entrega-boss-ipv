extends Control

@onready var aciertos: Label = $Aciertos;

func setUp(cant_aciertos: int)-> void:
	aciertos.text = aciertos.text + " " + str(cant_aciertos * 5);
	
