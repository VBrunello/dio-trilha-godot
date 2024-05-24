class_name Player
extends CharacterBody2D

@onready var animationPlayer: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D
@onready var attackCooldown: Timer = $attackCD
@onready var swordArea: Area2D = $SwordArea
@onready var hitBoxArea: Area2D = $HitboxArea
@onready var hitBoxCooldown: Timer = $HitboxCooldown
@onready var healthProgressBar: ProgressBar = $HealthProgressBar
@onready var ritualProgressBar: ProgressBar = $RitualProgressBar
@onready var audioPlayer: Node = $"../AudioManager"

@export_category("Movement")
@export var speed: float = 300
@export var lerpFactor: float = 0.05

@export_category("Sword")
@export var swordDamage: int = 2

@export_category("Ritual")
@export var ritualDamage: int = 1
@export var ritualInterval: float = 30
@export var ritualScene: PackedScene

@export_category("Health")
@export var deathPrefab: PackedScene
@export var health: int = 100
@export var maxHealth: int = 100

var inputVector: Vector2 = Vector2(0, 0)
var isRunning: bool = false
var wasRunning: bool = false
var isAttacking: bool = false
var isTimerEnded: bool = false
var canBeDamaged: bool = true
var ritualCooldown: float = 0.0

var damageSound
var magicSound

signal meatCollected(value: int)

func _ready():
	GameManager.player = self 
	meatCollected.connect(func(value: int): GameManager.meatCounter += 1)
	damageSound = audioPlayer.get_child(1)

func _process(delta):
	GameManager.playerPosition = position
	
	_read_input()
	if not isAttacking:
		_rotate_sprite()
	_play_run_idle_animation()
	
	# Ataque
	if Input.is_action_just_pressed("attack"):
		_attack()
		
	# Atualizar temporizador do ataque
	if isAttacking:
		if isTimerEnded:
			isAttacking = false
			isRunning = false
			isTimerEnded = false
			animationPlayer.play("knight_idle")
	
	#Processar Dano
	if canBeDamaged:
		_update_hitbox_detection()
	
	# Ritual
	_update_ritual(delta)
	
	healthProgressBar.max_value = maxHealth
	healthProgressBar.value = health
	ritualProgressBar.max_value = ritualInterval
	ritualProgressBar.value = ritualCooldown

func _update_ritual(delta: float):
	ritualCooldown -= delta
	if ritualCooldown > 0: return
	ritualCooldown = ritualInterval
	
	# Criar ritual
	var ritual = ritualScene.instantiate()
	ritual.damageAmount = ritualDamage
	add_child(ritual)

func _update_hitbox_detection():
	var bodies = hitBoxArea.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("enemies"):
			var enemy: Enemy = body
			var damage_amount = 1
			_damage(damage_amount)
			print("Tomei dano")
	
	canBeDamaged = false
	hitBoxCooldown.start()

func _physics_process(_delta):
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

func _deal_damage_to_enemies():
	var bodies = swordArea.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("enemies"):
			var enemy: Enemy = body
			var directionToEnemy = (enemy.position - position).normalized()
			var attackDirection: Vector2
			if sprite.flip_h:
				attackDirection = Vector2.LEFT
			else:
				attackDirection = Vector2.RIGHT
			var dotProduct = directionToEnemy.dot(attackDirection)
			if dotProduct >= 0.3:
				enemy._damage(swordDamage)


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

func _damage(amount: int):
	if health <= 0: return
	health -= amount
	damageSound.play(0.0)
	
	modulate = Color.RED
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUINT)
	tween.tween_property(self, "modulate", Color.WHITE, 0.3)
	
	if health <= 0:
		_die()

func _die():
	GameManager._end_game()
	if deathPrefab:
		var deathObject = deathPrefab.instantiate()
		get_parent().add_child(deathObject)
		deathObject.position = position
	queue_free()


func _on_hitbox_cooldown_timeout():
	canBeDamaged = true

func _heal(amount: int):
	health += amount
	if health > maxHealth:
		health = maxHealth
	return health


