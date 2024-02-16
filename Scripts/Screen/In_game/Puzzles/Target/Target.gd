extends Node2D

@onready var bow = $Bow
@onready var arrow = $Bow/Arrow
@onready var ball = $Bow/Arrow/Ball

var is_shot = false

func _input(event) -> void:
	
	if event is InputEventMouseMotion:
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and is_shot == false:
			arrow.position.x += (event.relative.x + -event.relative.y ) * 0.2
			arrow.position.x = clamp(arrow.position.x,-16,96)
			

func _process(delta) -> void:
	
	if is_shot:
		if float(ball.linear_velocity.x) <= 10:
			ball.freeze = true
			ball.position = Vector2()
			ball.linear_velocity = Vector2()
			arrow.position = Vector2(0,96)
			
			
			is_shot = false
	
	if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and is_shot == false:
		if arrow.position.x <= 50:
			is_shot = true
			ball.freeze = false
			
			ball.linear_velocity = Vector2(200,bow.rotation_degrees) * (arrow.position.distance_to(Vector2(92,0)) * 0.05)
			ball.angular_velocity = (arrow.position.distance_to(Vector2(92,0))* 0.6)
			return
		
		arrow.position.x = lerp(arrow.position.x,96.0,0.1)
		bow.look_at(get_global_mouse_position())
