extends Animated_Button

@export var tittle: String = "School"
@onready var tittle_node = $Tittle
	
var main

func _ready():
	tittle_node.text = tittle
	
	if disabled:
		material.set("shader_parameter/Gray",true)

func _pressed():
	main.emit_signal("school_selected",self)
