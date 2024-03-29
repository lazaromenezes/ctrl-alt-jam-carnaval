extends Control

func _ready():
	%ExitButton.visible = not OS.has_feature("web")

func _on_exit_button_pressed():
	get_tree().quit()

func _on_credits_button_pressed():
	SceneManager.transition_to(SceneManager.CreditsScreen)

func _on_play_button_pressed():
	SceneManager.transition_to(SceneManager.BriefingScreen)
