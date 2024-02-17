extends Control

signal school_selected(school: Control)
signal game_completed()

enum SCHOOLS {FLOR,KING,VENEZA,PINHEIROS}

@export var Schools_generation: Array[SCHOOLS] = []
@export var available_puzzles: Array[PackedScene] = []

@onready var schools_node = $Schools_gui/School_panel/Schools
@onready var tittle_text = $Gui/Panel/Tittle_text
@onready var school_panel = $Schools_gui/School_panel
@onready var puzzle_area = $PuzzleContainer/PuzzleArea/PanelContainer/Container
@onready var skip_puzzle = $PuzzleContainer/PuzzleArea/PanelContainer/SkipPuzzle
@onready var blur = $PuzzleContainer/PuzzleArea/PanelContainer/Blur

var new_escola_flor: PackedScene = preload("res://Scene/Screen/In_game/Schools/escola_da_flor.tscn")
var new_king_of_samba: PackedScene = preload("res://Scene/Screen/In_game/Schools/king_of_samba.tscn")
var new_veneza_show: PackedScene = preload("res://Scene/Screen/In_game/Schools/veneza_show.tscn")
var new_pinheiros: PackedScene = preload("res://Scene/Screen/In_game/Schools/pinheiros.tscn")

var next_school: int = 0

func _ready() -> void:
	_generate_schools()
	school_selected.connect(selection_school)
	game_completed.connect(_on_game_completed)

func _generate_schools() -> void:
	for schools_scenes: int in Schools_generation:
		var school
		
		match schools_scenes:
			SCHOOLS.FLOR:
				school = new_escola_flor.instantiate()
			SCHOOLS.KING:
				school  = new_king_of_samba.instantiate()
			SCHOOLS.VENEZA:
				school  = new_veneza_show.instantiate()
			SCHOOLS.PINHEIROS:
				school  = new_pinheiros.instantiate()
		
		school.main = self
		school.disabled = true
		schools_node.add_child(school)
	
	call_deferred("pass_schools")

func enabled_school(school: Control) -> void:
	school.disabled = false
	school.material.set("shader_parameter/Gray", false)

func selection_school(school: Control) -> void:
	tittle_text.text = school.tittle
	await create_tween()\
	.tween_property($PuzzleContainer, "visible", true, 0.3)\
	.set_ease(Tween.EASE_IN)\
	.finished
	
	var puzzle: Puzzle = available_puzzles.pick_random().instantiate()
	puzzle.solved.connect(_on_puzzle_solved)
	puzzle.skipped.connect(_on_puzzle_skipped)
	puzzle_area.add_child(puzzle)
	skip_puzzle.pressed.connect(puzzle.skip)
	
	#animation
	puzzle_area.modulate.a = 0
	
	var tw = get_tree().create_tween()
	
	tw.tween_property(puzzle_area,"modulate:a",1,0.3)\
	.set_trans(Tween.TRANS_BOUNCE)\
	.set_delay(0.4)
	
	tw.tween_property(blur,"modulate:a",1,0.3)\
	.set_trans(Tween.TRANS_BOUNCE)\
	.set_delay(0.4)

func pass_schools() -> void:
	var school: Control = schools_node.get_child(next_school)
	var tw = create_tween()
	
	enabled_school(school)
	selection_school(school)
	
	tw.tween_property(school_panel,"position:x",-school.position.x+200,0.3).set_trans(Tween.TRANS_CUBIC)
	next_school += 1
	
	if next_school > schools_node.get_child_count():
		game_completed.emit()
	
	tw.tween_property(blur,"modulate:a",0,0.3).set_trans(Tween.TRANS_BOUNCE)

func _on_puzzle_solved(time_reward: float):
	%MatchTimer.update(time_reward)
	await _close_puzzle_and_pass()

func _on_puzzle_skipped(time_penalty: float):
	%MatchTimer.update(time_penalty)
	await _close_puzzle_and_pass()

func _close_puzzle_and_pass():
	await create_tween()\
	.tween_property($PuzzleContainer, "visible", false, 0.3)\
	.set_ease(Tween.EASE_IN)\
	.finished
	
	puzzle_area.get_child(0).call_deferred("queue_free")
	pass_schools()

func _on_match_timer_timeout():
	$GameOver.show()
	await create_tween().tween_property($BackgroundSamba, "pitch_scale", 0.05, 0.75).finished

func _on_game_completed():
	$Congratulations.show()
	await create_tween().tween_property($BackgroundSamba, "pitch_scale", 1.5, 0.75).finished
	
