extends Control

signal school_selected(school: Control)
signal puzzle_completed()

enum SCHOOLS {FIRST,SECOND,THIRD}


@export var Schools_generation: Array[SCHOOLS] = []

@onready var schools_node = $Schools_gui/School_panel/Schools
@onready var tittle_text = $Gui/Panel/Tittle_text
@onready var school_panel = $Schools_gui/School_panel


var new_firt_school: PackedScene = preload("res://Scene/Screen/In_game/Schools/school_first.tscn")
var new_second_school: PackedScene = preload("res://Scene/Screen/In_game/Schools/school_second.tscn")
var new_third_school: PackedScene = preload("res://Scene/Screen/In_game/Schools/school_third.tscn")


func _ready() -> void:
	_generate_schools()
	connect("school_selected",selection_school)


func _generate_schools() -> void:
	for schools_scenes: int in Schools_generation:
		var school
		
		match schools_scenes:
			SCHOOLS.FIRST:
				school = new_firt_school.instantiate()
			SCHOOLS.SECOND:
				school  = new_second_school.instantiate()
			SCHOOLS.THIRD:
				school  = new_third_school.instantiate()
		
		school.main = self
		school.disabled = true
		schools_node.add_child(school)
	
	call_deferred("pass_schools",0)


func enabled_school(school: Control) -> void:
	school.disabled = false
	school.material.set("shader_parameter/Gray",false)


func selection_school(school: Control) -> void:
	tittle_text.text = school.tittle


func pass_schools(index: int) -> void:
	var school: Control = schools_node.get_child(index)
	var tw = create_tween()
	
	enabled_school(school)
	selection_school(school)
	
	tw.tween_property(school_panel,"position:x",-school.position.x+200,0.3).set_trans(Tween.TRANS_CUBIC)




#Debug================================
var prox = 1
func _on_pass_button_pressed():
	pass_schools(prox)
	prox += 1
	
	if schools_node.get_child_count() <= prox:
		prox = 0
