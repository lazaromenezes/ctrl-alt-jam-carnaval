extends Control

var TITLE_SCREEN: PackedScene = preload("res://Scene/Screen/In_game/TitleScreen.tscn")

func _on_anima_animation_finished(anim_name):
	SceneManager.transition_to(TITLE_SCREEN)
