extends Area2D
class_name MemoryTile

signal flipped()

var data: MemoryTileData = null

var _is_flipped: bool = true
var matched: bool = false

func setup(tileData: MemoryTileData, game: Memory):
	data = tileData
	$FrontFace.set_texture(data.texture)
	$BackFace.set_texture(game.back_tile)
	
	var collision_shape = RectangleShape2D.new()
	collision_shape.size = game.tile_size
	$CollisionShape2D.shape = collision_shape

func flip():
	if not matched:
		_is_flipped = not _is_flipped
		$FrontFace.visible = _is_flipped
		$BackFace.visible = not _is_flipped

		if _is_flipped:
			flipped.emit()

func _on_start_timer_timeout():
	flip()

func _on_input_event(_viewport, event: InputEvent, _shape_idx):
	if event.is_action_pressed("puzzles.memory.flip") and not _is_flipped:
		flip()
