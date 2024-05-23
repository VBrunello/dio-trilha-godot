extends Node

signal game_over

var playerPosition: Vector2
var player: Player
var isGameOver: bool = false

var timeElapsed: float = 0.0
var timeElapsedString: String
var meatCounter: int = 0
var monsterDefeatedCounter: int

func _process(delta: float):
	timeElapsed += delta
	var timeElapsedSeconds: int = floori(timeElapsed)
	var seconds: int = timeElapsedSeconds % 60
	var minutes: int = timeElapsedSeconds / 60
	
	timeElapsedString = "%02d:%02d" % [minutes, seconds] 

func _end_game():
	if isGameOver: return
	isGameOver = true
	game_over.emit()

func _reset():
	player = null
	playerPosition = Vector2.ZERO
	isGameOver = false
	
	timeElapsed = 0.0
	timeElapsedString = "0:00"
	meatCounter = 0
	monsterDefeatedCounter = 0
	
	for connection in game_over.get_connections():
		game_over.disconnect(connection.callable)
