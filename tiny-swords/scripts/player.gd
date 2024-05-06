extends CharacterBody2D

@onready var animationPlayer: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D
@onready var attackCooldown: Timer = $attackCD

@export var speed: float = 300
@export var lerpFactor: float = 0.05

var inputVector: Vector2 = Vector2(0, 0)
var isRunning: bool = false
var wasRunning: bool = false
var isAttacking: bool = false
var isTimerEnded: bool = false

func _process(delta):
	_read_input()
	_rotate_sprite()
	_play_run_idle_animation()
	
	# Ataque
	if Input.is_action_just_pressed("attack"):
		_attack()
	
	print(isRunning)
	
	# Atualizar temporizador do ataque
	if isAttacking:
		if isTimerEnded:
			isAttacking = false
			isRunning = false
			isTimerEnded = false
			animationPlayer.play("knight_idle")

func _physics_process(delta):
	_movement()

func _read_input():
	# Obter o input.vector
	inputVector = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	# Atualizar o isRunning
	wasRunning = isRunning
	isRunning = not inputVector.is_zero_approx()

func _movement():
	# Modificar velocidade
	var targetVelocity = inputVector * speed
	if isAttacking:
		targetVelocity *= 0.25
	velocity = lerp(velocity, targetVelocity, lerpFactor)
	move_and_slide()

func _attack():
	if isAttacking:
		return
	
	# Tocar animação
	animationPlayer.play("knight_attack_side_1")
	
	# Marcar ataque
	isAttacking = true
	
	# Começar timer
	attackCooldown.start()

func _play_run_idle_animation():
	# Tocar animação
	if not isAttacking:
		if wasRunning != isRunning:
			if isRunning:
				animationPlayer.play("knight_run")
			else:
				animationPlayer.play("knight_idle")

func _rotate_sprite():
	# Virar sprite
	if inputVector.x > 0:
		sprite.flip_h = false
	elif inputVector.x < 0:
		sprite.flip_h = true

func _on_attack_cd_timeout():
	isTimerEnded = true
