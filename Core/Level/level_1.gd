extends Node2D
@onready var tile_map_layer: TileMapLayer = $GroundTiles
@onready var obstacle_tiles: TileMapLayer = $ObstacleTiles

@export var pause : bool = false
#@export_tool_button("reset") var reset_tile = reset_tiles
var speed = 0.01
var player_position
@export var debug: bool = false
var starting_tile_position : Vector2i= Vector2i.ZERO

signal update_y(y)

func _ready() -> void:
	GameState.gameOver.connect(on_game_over)
	$Avalache/Anim.play("Idle")
	$Avalache/Sprite1.play("idle")
	$Avalache/Sprite2.play("idle")

func on_game_over():
	if !debug:
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
		if map_pos.y%80 == 0:
			place_powerup(map_pos)

		#tile_map_layer.positiodn = converted
		obstacle_tiles.position = converted
		#print("converted ", converted)
		
		#print(tile_map_layer.position)


func place_powerup(map_pos):
	var random_x = randi_range(-30,30)
	var power_ups = [1]
	var power_up_pos = map_pos + Vector2i(random_x,map_pos.y)
	power_up_pos = Vector2i(power_up_pos.x, abs(power_up_pos.y))

	obstacle_tiles.set_cell(power_up_pos, 5,Vector2.ZERO,power_ups.pick_random())
		
func place_obstacle(map_pos):
	const OBSTACLE_PATTERN_LOOT_TABLE : LootTable = preload("uid://2xx0sbw5i066")
	#var obstacles_arr : Array[LootObject] = OBSTACLE_PATTERN_LOOT_TABLE.item_results
	#if obstacles_arr.size() > 1:
		#var proper_obstacle = obstacles_arr
		#var obstacle_pos = map_pos + Vector2i(0,map_pos.y)
		#obstacle_pos = Vector2i(obstacle_pos.x, abs(obstacle_pos.y))
		#obstacle_tiles.set_cell(obstacle_pos, 4,Vector2.ZERO,proper_obstacle)
	#else:
		#push_error("obstacle arr empty loot object")
