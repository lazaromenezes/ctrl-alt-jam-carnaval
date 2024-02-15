extends Control

signal clicked()

@export_category("Labels")
@export var title: String = ""
@export_multiline var message: String = ""
@export var button: String = ""

func _ready():
	%Title.text = title
	%Message.text = message
	%Button.text = button

func _on_button_pressed():
	clicked.emit()
