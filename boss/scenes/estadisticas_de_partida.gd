extends Control

func setUp(cant_aciertos: int)-> void:
	var aciertosText: Label = $PanelContainer3/ContainerButtons/Aciertos
	aciertosText.text = aciertosText.text + " " + str(int(cant_aciertos * 5));

#Podria resultar usar señales de alguna manera
#func on_recibir_puntos() -> void:
#	pass
