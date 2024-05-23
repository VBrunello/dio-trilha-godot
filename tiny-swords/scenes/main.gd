extends Node2D

@export var gameUI: CanvasLayer
@export var gameOverUITemplate: PackedScene

func _ready():
	GameManager.game_over.connect(_trigger_game_over)

func _trigger_game_over():
	# Deletar game UI
	if gameUI:
		gameUI.queue_free()
		gameUI = null
	
	# Criar GameOverUI
	var gameOverUI: GameOverUI = gameOverUITemplate.instantiate()
	add_child(gameOverUI)
	
