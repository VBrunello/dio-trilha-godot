extends CanvasLayer

@onready var timerLabel = %TimerLabel
@onready var meatLabel = %MeatLabel

func _process(delta):
	timerLabel.text = GameManager.timeElapsedString
	meatLabel.text = str(GameManager.meatCounter)

