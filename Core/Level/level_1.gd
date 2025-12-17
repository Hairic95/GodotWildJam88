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
		if map_pos.y%30 == 0:
			place_obstacle(map_pos)
			print(converted)

		#tile_map_layer.positiodn = converted
		obstacle_tiles.position = converted
		#print("converted ", converted)
		
		#print(tile_map_layer.position)
		
func place_obstacle(map_pos):
	print("map ", map_pos)
	var obstacles = [2,3,4,5]
	var obstacle_pos = map_pos + Vector2i(0,map_pos.y)
	obstacle_pos = Vector2i(obstacle_pos.x, abs(obstacle_pos.y))
	print("obstace pos ", obstacle_pos)
	obstacle_tiles.set_cell(obstacle_pos, 4,Vector2.ZERO,obstacles.pick_random())
	
