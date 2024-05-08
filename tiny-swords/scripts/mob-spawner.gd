extends Node2D

@onready var pathFollow2D: PathFollow2D = %PathFollow2D

@export var creatures: Array[PackedScene]

func _process(delta):
	
	pass

func _get_point() -> Vector2:
	pathFollow2D.progress_ratio = randf()
	return pathFollow2D.position
