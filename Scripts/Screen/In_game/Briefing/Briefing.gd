extends Control

@export var read_time: float = 2
@export var transition_time: float = 0.75

var _full_opacity: Color = Color.WHITE
var _trasparent: Color = Color(1, 1, 1, 0)

var main_scene: String = "res://Scene/Screen/In_game/main.tscn"

var resorces_to_load = [
	#"res://Assets/Art/Others/Ball.svg",
	#"res://Assets/Art/Others/Ball_#path257.svg",
	#"res://Assets/Art/Others/Border.svg",
	#"res://Assets/Art/Others/Pista.svg",
	#"res://Assets/Art/Others/Cloud/cloud_0.svg",
	#"res://Assets/Art/Others/Cloud/cloud_1.svg",
	#"res://Assets/Art/Others/Cloud/cloud_2.svg",
	#"res://Assets/Art/Persons/Background/back_0.svg",
	#"res://Assets/Art/Persons/Background/back_1.svg",
	#"res://Assets/Art/Persons/Background/back_2.svg",
	#"res://Assets/Art/Persons/All_persons.svg",
	#"res://Assets/Art/Others.svg",
	#"res://Assets/Audio/sambajam Edit 1 Export 2.ogg",
	#"res://Resources/Puzzles/EightPuzzle/coringa.tres",
	#"res://Resources/Puzzles/EightPuzzle/tropical_mask.tres",
	#"res://Resources/Puzzles/EightPuzzle/veneza_mask.tres",
	#"res://Resources/Puzzles/Memory/flags.tres"
	main_scene
]

func _ready():
	for resource in resorces_to_load:
		ResourceLoader.load_threaded_request(resource)
		
	for page: Control in $Pages.get_children():
		await _fade_in(page)
		await get_tree().create_timer(read_time).timeout
		if page != %LastPage:
			await _fade_out(page)

func _fade_in(node: Control):
	node.show()
	await create_tween()\
	.tween_property(node, "modulate", _full_opacity, transition_time)\
	.set_ease(Tween.EASE_IN)\
	.finished
	
func _fade_out(node: Control):
	await create_tween()\
	.tween_property(node, "modulate", _trasparent, transition_time)\
	.set_ease(Tween.EASE_OUT)\
	.finished
	
	node.hide()

func _on_play_button_pressed():
	var main = ResourceLoader.load_threaded_get(main_scene)
	SceneManager.transition_to(main)
