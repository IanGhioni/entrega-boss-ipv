extends Control

signal siguiente_btn;
signal cerrar_btn;

@onready var titulo_label: Label = $Panel/Titulo
@onready var descripcion_label: Label = $Panel/Descripcion
@onready var tutorial_layout: CanvasLayer = $"../../.."

@onready var siguiente_button: Button = $Panel/SiguienteButton
@onready var cerrar_button: Button = $Panel/CerrarButton

@export var titulo: String;
@export var descripcion: String;

func _ready() -> void:
	titulo_label.text = titulo;
	descripcion_label.text = descripcion;

func setTitulo(titulo_nuevo: String) -> void:
	titulo_label.text = titulo_nuevo;
	
func setInstruccion(desc: String) -> void:
	descripcion_label.text = desc;

func _on_cerrar_button_pressed() -> void:
	tutorial_layout.hide();

func cambiarBtn():
	siguiente_button.visible = not siguiente_button.visible
	cerrar_button.visible    = not cerrar_button.visible

func _on_siguiente_button_pressed() -> void:
	siguiente_btn.emit();
