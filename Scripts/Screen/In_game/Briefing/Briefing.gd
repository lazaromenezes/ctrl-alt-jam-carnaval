extends Control

@export var read_time: float = 2
@export var transition_time: float = 0.75

var main_scene: String = "res://Scene/Screen/In_game/main.tscn"

func _ready():
	ResourceLoader.load_threaded_request(main_scene)
		
	for page: Control in $Pages.get_children():
		await _fade_in(page)
		await get_tree().create_timer(read_time).timeout
		if page != %LastPage:
			await _fade_out(page)

func _fade_in(node: Control):
	await create_tween()\
	.tween_property(node, "modulate:a", 1, transition_time)\
	.set_ease(Tween.EASE_IN)\
	.finished
	
func _fade_out(node: Control):
	await create_tween()\
	.tween_property(node, "modulate:a", 0, transition_time)\
	.set_ease(Tween.EASE_OUT)\
	.finished

func _on_play_button_pressed():
	var main = ResourceLoader.load_threaded_get(main_scene)
	SceneManager.transition_to(main)
