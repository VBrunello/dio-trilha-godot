extends CharacterBody2D

@export var speed = 300
@export_range(0, 1) var lerpFactor = 0.5

@onready var sprite = %Sprite

func _physics_process(_delta):

	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var targetVelocity = direction * speed
	velocity = lerp(velocity, targetVelocity, lerpFactor)
	move_and_slide()
	
	var targetRotation = direction.x * 45
	sprite.rotation_degrees = lerp(sprite.rotation_degrees, targetRotation, lerpFactor)
