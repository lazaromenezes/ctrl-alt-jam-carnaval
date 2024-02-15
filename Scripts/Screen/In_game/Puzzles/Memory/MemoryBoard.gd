extends Puzzle

const ROW_SIZE: int = 4
const MARGIN: int = 5
const OFFSET_FACTOR: float = -1.5

@export var settings: Memory = null

var MemoryTileScene = preload("res://Scene/Screen/In_game/Puzzles/Memory/MemoryGameTile.tscn")
var _tiles: Array[MemoryTile] = []
var _offset: Vector2

var _current_tile: MemoryTile

func _ready():
	_offset = settings.tile_size * OFFSET_FACTOR
	_create_tiles()
	_tiles.shuffle()
	_place_tiles()
	
func _create_tiles():
	for i in settings.tiles.size() * 2:
		@warning_ignore("integer_division")
		var data: MemoryTileData = settings.tiles[i / 2]
		var tile: MemoryTile = MemoryTileScene.instantiate()
		tile.setup(data, settings)
		tile.flipped.connect(_on_flipped)
		_tiles.push_back(tile)
		
func _place_tiles():
	for i:int in _tiles.size():
		_tiles[i].position.x = (settings.tile_size.x + MARGIN) * (i % ROW_SIZE) + _offset.x
		@warning_ignore("integer_division")
		_tiles[i].position.y = (settings.tile_size.y + MARGIN) * (i / ROW_SIZE) + _offset.y
		
		add_child(_tiles[i])

func _on_flipped(flipped_tile: MemoryTile):
	if not _current_tile:
		_current_tile = flipped_tile
	else:
		if _current_tile.data.value == flipped_tile.data.value:
			_check_solution()
		else:
			await get_tree().create_timer(0.5).timeout
			_current_tile.flip()
			flipped_tile.flip()
		
		_current_tile = null
	
func _check_solution():
	if get_children().all(func(t): return t.is_flipped):
		solved.emit(time_reward)
