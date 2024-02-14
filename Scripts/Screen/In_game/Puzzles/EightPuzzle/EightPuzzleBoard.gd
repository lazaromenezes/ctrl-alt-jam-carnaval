extends Puzzle

const TILE_SIZE: int = 128
const ROW_SIZE: int = 3
const POSITIONS: Dictionary = {
	0: Vector2(-TILE_SIZE, -TILE_SIZE),
	1: Vector2(0, -TILE_SIZE),
	2: Vector2(TILE_SIZE, -TILE_SIZE),
	3: Vector2(-TILE_SIZE, 0),
	4: Vector2.ZERO,
	5: Vector2(TILE_SIZE, 0),
	6: Vector2(-TILE_SIZE, TILE_SIZE),
	7: Vector2(0, TILE_SIZE),
	8: Vector2(TILE_SIZE, TILE_SIZE)
}

const MOVES_TO_CHECK: Array[Vector2i] = [
	Vector2i.UP, Vector2i.DOWN, Vector2i.LEFT, Vector2i.RIGHT
]

@export var available_puzzles: Array[EightPuzzle] = []

var EightPuzzleTileScene = preload("res://Scene/Screen/In_game/Puzzles/EightPuzzle/Eight_Puzzle_Tile.tscn")
var tiles: Array[EightPuzzleTile] = [null]
var empty_place: int

func _ready():
	var current_puzzle: EightPuzzle = available_puzzles.pick_random()
	
	_create_tiles(current_puzzle)
	
	_shuffle_tiles()
	
	_place_tiles()

func _create_tiles(puzzle: EightPuzzle) -> void:
	for tile_data in puzzle.tiles:
		var tile: EightPuzzleTile = EightPuzzleTileScene.instantiate()
		tile.tile_data = tile_data
		tile.clicked.connect(_on_tile_clicked)
		tiles.push_back(tile)

func _place_tiles() -> void:
	for i in tiles.size():
		var tile = tiles[i]
		
		if tile == null:
			empty_place = i
		else:
			tile.position = POSITIONS[i]
			tile.current_place = i
			add_child(tile)

func _on_tile_clicked(tile: EightPuzzleTile) -> void:
	if _can_move_from(tile.current_place):
		_move_tile_to_empty_place(tile)
		_check_resolution()

func _can_move_from(place: int) -> bool:
	var x: int = place % ROW_SIZE
	var y: int = place / ROW_SIZE
	
	var grid_place: Vector2i = Vector2i(x, y)
	
	for move in MOVES_TO_CHECK:
		var candidate: Vector2i = grid_place + move
		
		if candidate.x >= 0 and candidate.x < ROW_SIZE and candidate.y >= 0 and candidate.y < ROW_SIZE:
			var index: int = candidate.y * ROW_SIZE + candidate.x
			
			if index == empty_place:
				return true 
	
	return false

func _move_tile_to_empty_place(tile: EightPuzzleTile) -> void:
	var old_tile_place = tile.current_place
	tile.current_place = empty_place
	create_tween().tween_property(tile, "position", POSITIONS[empty_place], 0.1)
	empty_place = old_tile_place

func _check_resolution() -> void:
	var all_correct = tiles \
		.filter(func(t): return t != null) \
		.all(func(t: EightPuzzleTile): return t.is_correct())
		
	if all_correct:
		solved.emit()

func _shuffle_tiles():
	tiles.shuffle()
	while not _can_resolve():
		tiles.shuffle()

# https://www.geeksforgeeks.org/check-instance-8-puzzle-solvable/
func _can_resolve() -> bool:
	var inversions: int = 0
	
	for i in range(9):
		for j in range(i + 1, 9):
			if tiles[j] and tiles[i] and tiles[i].tile_data.correct_position > tiles[j].tile_data.correct_position:
				inversions += 1
	
	return inversions % 2 == 0
