extends Area2D
class_name EightPuzzleTile

signal clicked(tile)

var tile_data: EightPuzzleTileData:
	set(data):
		tile_data = data
		$TileSprite.set_texture(data.texture)

var current_place: int = 0

func is_correct():
	return current_place == tile_data.correct_position

func _on_input_event(_viewport, event: InputEvent, _shape_idx):
	if event.is_action_pressed("puzzles.eight_tile.move_tile"):
		clicked.emit(self)

