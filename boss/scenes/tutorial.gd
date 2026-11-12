extends Control

@onready var instruccion: Control = $TutorialLayout/Control/ColorRect/Instruccion
@onready var tutorial_layout: CanvasLayer = $TutorialLayout
@onready var campana_container: Control = $CampanaContainer

var fase_tutorial: int = 0; 
# Variable que vamos a usar para ordenar las escenas de tutorial. 
# Usandolo como índice para los dialogos.

var titulos_list: Array = [
	"¡Bienvenido,",
	"¡Que pase el siguiente!",
	"Revisar documentos",
]

var descripcion_list: Array = [
	"guardia de la frontera!",
	"Toca la campana para llamar a los siguientes fronterizos",
	"Consultá con tu compañero como averiguar si son legales",
]

func _ready() -> void:
	_actualizar_cuadro_tutorial();

func _on_campana_container_se_activo_campana() -> void:
	campana_container.desabilitarBoton();
	await get_tree().create_timer(2.5).timeout
	_aumentar_fase();
	_actualizar_cuadro_tutorial()
	_mostrar_pantalla_tutorial();

func _mostrar_pantalla_tutorial() -> void:
	tutorial_layout.show();

func _aumentar_fase() -> void:
	fase_tutorial += 1;

func _actualizar_cuadro_tutorial() -> void:
	instruccion.setTitulo(titulos_list[fase_tutorial]);
	instruccion.setInstruccion(descripcion_list[fase_tutorial]);
