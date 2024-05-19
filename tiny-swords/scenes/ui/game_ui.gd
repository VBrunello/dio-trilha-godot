extends CanvasLayer

@onready var timerLabel = %TimerLabel
@onready var meatLabel = %MeatLabel

var timeElapsed: float = 0.0
var meatCounter: int = 0

func _ready():
	GameManager.player.meatCollected.connect(_onMeatCollected)
	meatCounter = 0

func _process(delta: float):
	timeElapsed += delta
	var timeElapsedSeconds: int = floori(timeElapsed)
	var seconds: int = timeElapsedSeconds % 60
	var minutes: int = timeElapsedSeconds / 60
	
	timerLabel.text = "%02d:%02d" % [minutes, seconds] 

func _onMeatCollected(regeneration_value: int):
	meatCounter += 1
	meatLabel.text = str(meatCounter)
