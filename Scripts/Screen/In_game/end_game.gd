extends Control

@export_category("Labels")
@export var title: String = ""
@export_multiline var message: String = ""
@export var button: String = ""

func _ready():
	%Title.text = title
	%Message.text = message
	%MenuButton.text = button

func _on_menu_button_pressed():
	SceneManager.back_to_title()
