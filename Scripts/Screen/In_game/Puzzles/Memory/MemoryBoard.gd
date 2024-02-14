extends Puzzle

const ROW_SIZE: int = 4
const MARGIN: int = 5

@export var settings: Memory = null

var MemoryTileScene = preload("res://Scene/Screen/In_game/Puzzles/Memory/MemoryGameTile.tscn")
var _tiles: Array[MemoryTile] = []
var _offset: Vector2

func _ready():
	_offset = settings.tile_size * -1.5
	_create_tiles()
	_tiles.shuffle()
	_place_tiles()
	
func _create_tiles():
	for i in settings.tiles.size() * 2:
		@warning_ignore("integer_division")
		var data: MemoryTileData = settings.tiles[i / 2]
		var tile: MemoryTile = MemoryTileScene.instantiate()
		tile.setup(data, settings)
		_tiles.push_back(tile)
		
func _place_tiles():
	for i:int in _tiles.size():
		_tiles[i].position.x = (settings.tile_size.x + MARGIN) * (i % ROW_SIZE) + _offset.x
		@warning_ignore("integer_division")
		_tiles[i].position.y = (settings.tile_size.y + MARGIN) * (i / ROW_SIZE) + _offset.y
		
		add_child(_tiles[i])
