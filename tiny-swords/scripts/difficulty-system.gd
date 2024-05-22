extends Node

@export var mobsIncreasedPerMinute: float = 30.0
@export var mobSpawner: MobSpawner
@export var waveDuration: float = 20.0
@export var initialSpawnRate: float = 60.0
@export var breakIntensity: float = 0.5

var time = 0.0

func _process(delta):
	time += delta
	
	# Dificuldade linear 
	var spawnRate = initialSpawnRate + mobsIncreasedPerMinute * (time / 60.0)
	
	# Sistema de wave
	var sinWave = sin((time * TAU) / waveDuration)
	var waveFactor = remap(sinWave, -1.0, 1.0, breakIntensity, 1)
	spawnRate += waveFactor
	
	mobSpawner.mobsPerMinute = spawnRate
