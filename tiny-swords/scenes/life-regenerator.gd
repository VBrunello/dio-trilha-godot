extends Node2D


@export var regenerationAmount: int = 10



func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		var player: Player = body
		player._heal(regenerationAmount)
		queue_free()
