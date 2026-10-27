
extends Node2D

var sprite: AnimatedSprite2D
var en_movimiento: bool = false


func configurar(escena_visual: PackedScene) -> void:
	# Crear el personaje visual.
	var visual = escena_visual.instantiate()

	# La escena visual tiene AnimatedSprite2D como raíz.
	sprite = visual as AnimatedSprite2D

	if sprite == null:
		push_error("La escena visual debe tener AnimatedSprite2D como raíz.")
		visual.free()
		return

	# Incorporarlo al NPC.
	add_child(sprite)
	sprite.position = Vector2.ZERO
	sprite.play("idle")


func caminar_hacia(
		destino: Vector2,
		duracion: float = 2.0
) -> void:
	if sprite == null:
		return

	en_movimiento = true
	sprite.play("walk")

	if destino.x != global_position.x:
		sprite.flip_h = destino.x < global_position.x

	var tween = create_tween()
	tween.tween_property(self, "global_position", destino, duracion)

	await tween.finished

	sprite.play("idle")
	en_movimiento = false


func hablar() -> void:
	if sprite != null and not en_movimiento:
		sprite.play("talk")


func dejar_de_hablar() -> void:
	if sprite != null and not en_movimiento:
		sprite.play("idle")
