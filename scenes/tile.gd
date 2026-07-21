extends Area2D

class_name Tile

signal tile_clicked(tile)

@export var tile_type: int = 0
var grid_x: int = 0
var grid_y: int = 0

func _input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		emit_signal("tile_clicked", self)
