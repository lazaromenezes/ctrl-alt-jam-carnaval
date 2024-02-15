extends Control

signal timeout()

@export var time: float

const TIME_TEMPLATE: String = "%02d:%02d"

func _ready():
	$Timer.start(time)
	$Timer.timeout.connect(func(): timeout.emit())

func _process(_delta):
	var time_left = $Timer.time_left
	var minutes: float = time_left / 60
	var seconds: float = fmod(time_left, 60)
	
	$TimerLabel.text = TIME_TEMPLATE % [minutes, seconds]
