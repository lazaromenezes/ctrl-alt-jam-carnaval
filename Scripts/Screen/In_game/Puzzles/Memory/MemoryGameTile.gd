extends Area2D
class_name MemoryTile

signal flipped(flipped_tile: MemoryTile)

var data: MemoryTileData = null
var is_flipped: bool = true

func setup(tileData: MemoryTileData, game: Memory):
	data = tileData
	$FrontFace.set_texture(data.texture)
	$BackFace.set_texture(game.back_tile)
	
	var collision_shape = RectangleShape2D.new()
	collision_shape.size = game.tile_size
	$CollisionShape2D.shape = collision_shape

func flip():
	is_flipped = not is_flipped
	$FrontFace.visible = is_flipped
	$BackFace.visible = not is_flipped

	if is_flipped:
		flipped.emit(self)

func _on_start_timer_timeout():
	flip()

func _on_input_event(_viewport, event: InputEvent, _shape_idx):
	if event.is_action_pressed("puzzles.memory.flip") and not is_flipped:
		flip()
