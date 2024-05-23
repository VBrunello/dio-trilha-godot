class_name MobSpawner
extends Node2D

@onready var pathFollow2D: PathFollow2D = %PathFollow2D

@export var creatures: Array[PackedScene]
var mobsPerMinute: float = 60

var cooldown = 0.0


func _process(delta):
	if GameManager.isGameOver: return
	
	cooldown -= delta
	if cooldown > 0: return
	
	var interval = 60.0 / mobsPerMinute
	cooldown = interval
	
	# Checar se o ponto é valido
	var point = _get_point()
	# Perguntar pro jogo se o ponto tem colisão
	var worldState = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = point
	var result: Array = worldState.intersect_point(parameters, 1)
	if not result.is_empty(): return
	
	var index = randi_range(0, creatures.size() - 1)
	var creatureScene = creatures[index]
	var creature = creatureScene.instantiate()
	creature.global_position = point
	get_parent().add_child(creature)

func _get_point() -> Vector2:
	pathFollow2D.progress_ratio = randf()
	return pathFollow2D.global_position
