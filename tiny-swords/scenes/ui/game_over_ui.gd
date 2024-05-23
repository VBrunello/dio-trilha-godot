class_name GameOverUI
extends CanvasLayer

@onready var timeLabel: Label = %TimeLabel
@onready var monsterLabel: Label = %MonstersLabel

@export var restartDelay: float = 5.0

var restartCooldown: float

func _ready():
	timeLabel.text = GameManager.timeElapsedString
	monsterLabel.text = str(GameManager.monsterDefeatedCounter)
	restartCooldown = restartDelay

func _process(delta):
	restartCooldown -= delta
	if restartCooldown <= 0.0:
		_restart_game()

func _restart_game():
	GameManager._reset()
	get_tree().reload_current_scene()
