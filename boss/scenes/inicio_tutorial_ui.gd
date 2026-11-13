extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	size.x = get_viewport_rect().size.x;
	size.y = get_viewport_rect().size.y;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
