extends Node

@export var speed: float = 1

var sprite: AnimatedSprite2D
var enemy: Enemy
var inputVector

func _ready():
	enemy = get_parent()
	sprite = enemy.get_node("Sprite")
	pass

func _physics_process(_delta):
	# Calcular direção
	var playerPosition: Vector2 = GameManager.playerPosition
	var difference = playerPosition - enemy.position
	inputVector = difference.normalized()
	
	# Movimento
	enemy.velocity = inputVector * speed * 100
	enemy.move_and_slide()
	
	# Girar sprite
	_rotate_sprite()

func _rotate_sprite():
	# Virar sprite
	if inputVector.x > 0:
		sprite.flip_h = false
	elif inputVector.x < 0:
		sprite.flip_h = true
