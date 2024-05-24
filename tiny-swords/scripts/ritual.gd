extends Node2D

@onready var area2d: Area2D = $Area2D
@onready var ritualSound: AudioStreamPlayer = $RitualSound

@export var damageAmount: int = 1


func _deal_damage():
	var bodies = area2d.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("enemies"):
			var enemy: Enemy = body
			enemy._damage(damageAmount)

func _play_ritual_sound():
	ritualSound.play(0.0)
