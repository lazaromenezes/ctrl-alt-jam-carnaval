extends CanvasLayer

signal timeout()

@export var add_color: Color = Color.WEB_GREEN
@export var remove_color: Color = Color.WEB_MAROON
@export var fade_time: float = 0.75
@export var fade_movement: Vector2 = Vector2(0, -200)

@export var time: float

const TIME_TEMPLATE: String = "%02d:%02d"

var _target_fade_position: Vector2

func _ready():
	_target_fade_position = $Time_Tex/TimerLabel.position + fade_movement
	$Timer.start(time)
	$Timer.timeout.connect(func(): timeout.emit())

func _process(_delta):
	$Time_Tex/TimerLabel.text = _format_time($Timer.time_left)

func update(time_change: float):
	var new_time = clamp($Timer.time_left + time_change, 0.1, 90)
	$Timer.start(new_time)
	
	var mini_label = _crate_mini_label(time_change)
	$Time_Tex.add_child(mini_label)
	_fade_mini_label_out(mini_label)

func _format_time(time_value):
	var minutes: float = time_value / 60
	var seconds: float = fmod(time_value, 60)
	return TIME_TEMPLATE % [minutes, seconds]

func _crate_mini_label(time_change: float):
	var color = add_color if time_change > 0 else remove_color
	var mini_label = Label.new()
	mini_label.text = _format_time(time_change)
	mini_label.position = $Time_Tex/TimerLabel.position
	mini_label.set("theme_override_colors/font_color", color)	
	return mini_label

func _fade_mini_label_out(mini_label):
	var tween = create_tween()
	tween.tween_property(mini_label, "position", _target_fade_position, fade_time)
	tween.parallel().tween_property(mini_label, "modulate:a", 0, fade_time)
	tween.tween_callback(mini_label.queue_free)
