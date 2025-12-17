@tool
extends TileMapLayer

@export_tool_button("clear") var clear_tiles = clear_all_tiles

@export_tool_button("first line") var first_l = first_line

var first_bound = Vector2(-28,77)
var end_bound = Vector2(31,-41)

func clear_all_tiles():
	clear()

func first_line():
	pass
