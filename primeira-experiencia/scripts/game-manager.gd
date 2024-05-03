extends Node

export var objects_templates: Array

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == 1 and event.pressed:
			Spawn_Object(event.position)

func Spawn_Object(position: Vector2):
	var index: int = randi() % 3
	var object_template = objects_templates[index]
	var object: RigidBody2D = object_template.instance()
	object.position = position
	add_child(object)
