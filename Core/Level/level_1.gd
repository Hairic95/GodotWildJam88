@tool
extends Node2D
@onready var tile_map_layer: TileMapLayer = $GroundTiles
@onready var obstacle_tiles: TileMapLayer = $ObstacleTiles

@export var pause : bool = false
@export_tool_button("reset") var reset_tile = reset_tiles
var speed = 0.5
var player_position

var starting_tile_position : Vector2i= Vector2i.ZERO

func _ready() -> void:
	GameState.gameOver.connect(on_game_over)

func on_game_over():
	pause = true

func reset_tiles():
	tile_map_layer.position = Vector2.ZERO

func _process(delta: float) -> void:
	if !pause:
		var map_pos = starting_tile_position - Vector2i(0,1)
		print("map ", map_pos)
		
		starting_tile_position = map_pos
		var next_pos = map_pos  
		print("next ", next_pos)
		var converted = tile_map_layer.map_to_local(next_pos)
		#print("convert ",converted)
		#var next_pos = tile_map_layer.map_to_local()  * speed
		#print(next_pos)
		tile_map_layer.position = converted
		#obstacle_tiles.position = next_pos
		
		#print(tile_map_layer.position)
