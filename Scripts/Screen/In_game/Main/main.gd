extends Control

signal puzzle_completed()

enum SCHOOLS {FIRST,SECOND,THIRD}


@export() var Schools_generation: Array[SCHOOLS] = []
@onready var Schools_node = $Schools


var new_firt_school: PackedScene = preload("res://Scene/Screen/In_game/Schools/school_first.tscn")
var new_second_school: PackedScene = preload("res://Scene/Screen/In_game/Schools/school_second.tscn")
var new_third_school: PackedScene = preload("res://Scene/Screen/In_game/Schools/school_third.tscn")


func _ready() -> void:
	_generate_schools()


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
		
		Schools_node.add_child(school)

