extends Node2D
@onready var tile_map_layer: TileMapLayer = $GroundTiles
@onready var obstacle_tiles: TileMapLayer = $ObstacleTiles

@export var pause : bool = false
#@export_tool_button("reset") var reset_tile = reset_tiles
var speed = 0.01
var player_position

var starting_tile_position : Vector2i= Vector2i.ZERO

signal update_y(y)

func _ready() -> void:
	GameState.gameOver.connect(on_game_over)

func on_game_over():
	pause = true

func reset_tiles():
	tile_map_layer.position = Vector2.ZERO

func _process(delta: float) -> void:
	if !pause:
		var map_pos = starting_tile_position - Vector2i(0,1)
		update_y.emit(map_pos.y)
		starting_tile_position = map_pos 

		var converted = tile_map_layer.map_to_local(map_pos)/2
		print(converted)

		#tile_map_layer.positiodn = converted
		obstacle_tiles.position = converted
		
		#print(tile_map_layer.position)
