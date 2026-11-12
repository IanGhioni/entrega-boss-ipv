extends Control

signal siguiente_btn;

@onready var titulo_label: Label = $Panel/Titulo
@onready var descripcion_label: Label = $Panel/Descripcion
@onready var tutorial_layout: CanvasLayer = $"../../.."

@export var titulo: String;
@export var descripcion: String;

func _ready() -> void:
	titulo_label.text = titulo;
	descripcion_label.text = descripcion;

func _on_siguiente_button_pressed() -> void:
	tutorial_layout.hide();

func setTitulo(titulo_nuevo: String) -> void:
	titulo_label.text = titulo_nuevo;
	
func setInstruccion(desc: String) -> void:
	descripcion_label.text = desc;
