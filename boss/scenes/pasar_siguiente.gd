extends Control
signal se_activo_campana();
@onready var sonido_campana: AudioStreamPlayer2D = $PanelContainer/Siguiente/SonidoCampana
@onready var boton_campana: Button = $PanelContainer/Siguiente

func _on_siguiente_pressed() -> void:
	sonido_campana.play();
	se_activo_campana.emit();

func desabilitarBoton() -> void:
	boton_campana.disabled = true;

func desactivarDeteccionMouse() -> void:
	boton_campana.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND;

func activarDeteccionMouse() -> void:
	boton_campana.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND;
