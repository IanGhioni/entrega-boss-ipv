extends Control


func setUp(cant_aciertos: int)-> void:
	var aciertosText: Label = $PanelContainer3/ContainerButtons/Aciertos
	aciertosText.text = aciertosText.text + " " + str(cant_aciertos * 5);
