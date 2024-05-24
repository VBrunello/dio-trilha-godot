class_name Enemy
extends Node2D

@onready var damageDigitMarker = $DamageDigitMarker
@onready var audioPlayer: Node = $"../AudioManager"

@export_category("Life and Damage")
@export var deathPrefab: PackedScene
@export var health: int = 10

@export_category("Drops")
@export var dropChance: float = 0.1
@export var dropItems: Array[PackedScene]
@export var dropChances: Array[float]

var damageDigitPrefab: PackedScene

func _ready():
	damageDigitPrefab = preload("res://scenes/damage-digit.tscn")

func _damage(amount: int):
	health -= amount
	var playSound = audioPlayer.get_child(2)
	playSound.play(0.0)
	
	modulate = Color.RED
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUINT)
	tween.tween_property(self, "modulate", Color.WHITE, 0.3)
	
	# Criar a UI do dano nos inimigos
	var damageDigit = damageDigitPrefab.instantiate()
	damageDigit.value = amount
	if damageDigitMarker:
		damageDigit.global_position = damageDigitMarker.global_position
	else:
		damageDigit.global_position = global_position
	get_parent().add_child(damageDigit)
	
	
	if health <= 0:
		_die()

func _die():
	# Caveira
	if deathPrefab:
		var deathObject = deathPrefab.instantiate()
		get_parent().add_child(deathObject)
		deathObject.position = position
	
	# Incrementar contador
	GameManager.monsterDefeatedCounter += 1
	
	# Drop
	if randf() <= dropChance:
		_drop_item()
	
	# Deletar node
	queue_free()

func _drop_item():
	var drop = _get_random_drop_item().instantiate()
	drop.position = position
	get_parent().add_child(drop)

func _get_random_drop_item(): 
	# Listas com 1 item
	if dropItems.size() == 1:
		return dropItems[0]
	
	# Calcula chance máxima
	var max_chance: float = 0
	for dropChance in dropChances:
		max_chance += dropChance
	
	# Joga o dado
	var randomValue = randf() * max_chance
	
	# Girar roleta
	var needle: float = 0
	for i in dropItems.size():
		var dropItem = dropItems[i]
		var dropChance = dropChances[i] if i < dropChances.size() else 1
		if randomValue <= dropChance + needle:
			return dropItem
		needle += dropChance
	
	return dropItems[0]
