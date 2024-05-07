class_name Enemy
extends Node2D

@export var deathPrefab: PackedScene
@export var health: int = 10

func _damage(amount: int):
	health -= amount
	
	modulate = Color.RED
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUINT)
	tween.tween_property(self, "modulate", Color.WHITE, 0.3)
	
	if health <= 0:
		_die()

func _die():
	if deathPrefab:
		var deathObject = deathPrefab.instantiate()
		get_parent().add_child(deathObject)
		deathObject.position = position
	queue_free()
