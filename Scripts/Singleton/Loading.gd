extends CanvasLayer

@onready var anima = $Animation/Anima

var data_scene: PackedScene

func scene_pass(scene: PackedScene) -> void:
	anima.play("Start")
	
	data_scene = scene

func change_scene() -> void:
	get_tree().change_scene_to_packed(data_scene)
