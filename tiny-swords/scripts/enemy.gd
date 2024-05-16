class_name Enemy
extends Node2D

@onready var damageDigitMarker = $DamageDigitMarker

@export var deathPrefab: PackedScene
@export var health: int = 10

var damageDigitPrefab: PackedScene

func _ready():
	damageDigitPrefab = preload("res://scenes/damage-digit.tscn")

func _damage(amount: int):
	health -= amount
	
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
	if deathPrefab:
		var deathObject = deathPrefab.instantiate()
		get_parent().add_child(deathObject)
		deathObject.position = position
	queue_free()
