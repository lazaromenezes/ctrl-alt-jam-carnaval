extends BaseButton

class_name Animated_Button

@export_category("Animated Button")
@export var speed: float = 0.2
@export var enter_scale: float = 1.2
@export var exit_scale: float = 1


var save_scale_ready: Vector2


func _ready() -> void:
	connect("mouse_entered",_mouse_enter)
	connect("mouse_exited",_mouse_exit)
	
	save_scale_ready = scale
	pivot_offset = custom_minimum_size/2

func _mouse_enter() -> void:
	var Tw = create_tween()
	Tw.tween_property(self,"scale",save_scale_ready*enter_scale,speed).set_trans(Tween.TRANS_CUBIC)
	
	z_index = 1

func _mouse_exit() -> void:
	var Tw = create_tween()
	Tw.tween_property(self,"scale",save_scale_ready*exit_scale,speed).set_trans(Tween.TRANS_CUBIC)
	
	await Tw.finished
	z_index = 0
