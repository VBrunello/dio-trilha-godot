extends Node2D

@onready var audioPlayer: Node = $"../AudioManager"
@export var regenerationAmount: int = 10

func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		var playAudio = audioPlayer.get_child(0)
		playAudio.play(0.0)
		var player: Player = body
		player._heal(regenerationAmount)
		player.meatCollected.emit(regenerationAmount)
		queue_free()
