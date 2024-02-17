extends Node

var CreditsScreen: PackedScene = preload("res://Scene/Screen/In_game/credits.tscn")
var TitleScreen: PackedScene = preload("res://Scene/Screen/In_game/TitleScreen.tscn")
var BriefingScreen: PackedScene = preload("res://Scene/Screen/In_game/Briefing/Briefing.tscn")

func transition_to(screen: PackedScene):
	Loading.scene_pass(screen)
	
func back_to_title():
	transition_to(TitleScreen)
