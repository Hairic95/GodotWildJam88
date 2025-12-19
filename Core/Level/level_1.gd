extends Node2D

@export var pause : bool = false
@export var debug: bool = false
@export var obstacle_loot_table : LootTable
@export var power_up_loot_table : LootTable

@onready var tile_map_layer: TileMapLayer = $GroundTiles
@onready var obstacle_tiles: TileMapLayer = $ObstacleTiles
@onready var ui: CanvasLayer = $UI
@onready var camera_2d: Camera2D = $Camera2D
@onready var sprite_1: AnimatedSprite2D = $AvalanchePath2D3/AvalanchePathFollow2D/Avalache/Sprite1
@onready var sprite_2: AnimatedSprite2D = $AvalanchePath2D3/AvalanchePathFollow2D/Avalache/Sprite2
@onready var anim: AnimationPlayer = $AvalanchePath2D3/AvalanchePathFollow2D/Avalache/Anim

var player_position
var starting_tile_position : Vector2i= Vector2i.ZERO

signal update_y(y)

var speed_dictionary = {
	-4: 2.65,
	-3: 2.6,
	-2: 2.55,
	-1: 2.5,
	0: 2.45,
	1: 2.4,
	2: 2.3,
	3: 2.2,
	4: 2.1
}
var speed_inc_val = speed_dictionary[GameState.player_speed]

func _ready() -> void:
	GameState.gameOver.connect(on_game_over)
	anim.play("Idle")
	sprite_1.play("idle")
	sprite_2.play("idle")
	GameState.set_game_state.connect(on_set_game_state)
	on_set_game_state(GameState.starting_state)
	GameState.change_speed_amount.connect(on_change_speed)

func on_change_speed():
	var tween = get_tree().create_tween()
	var new_val = speed_dictionary[GameState.player_speed]
	tween.tween_property(self, "speed_inc_val",new_val, 2.0)

func on_set_game_state(state: GameState.States):
	match(state):
		GameState.States.MainMenu:
			pause = true
			ui.hide()
			camera_2d.enabled = false
			
		GameState.States.Game:
			pause = false
			ui.show()
			camera_2d.enabled = true

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("zoom_debug"):
		
		var normal_zoom = 0.1
		var normal_zoom_vec = Vector2(normal_zoom, normal_zoom)
		
		var zoom_out = 0.04
		var zoom_out_vec = Vector2(zoom_out, zoom_out)
		
		var mega_zoom = 0.01
		var mega_zoom_out_vec = Vector2(mega_zoom, mega_zoom)
		
		var camera_zoom = camera_2d.zoom
		match(camera_zoom):
			normal_zoom_vec:
				camera_2d.zoom = zoom_out_vec
			zoom_out_vec:
				camera_2d.zoom = mega_zoom_out_vec
			mega_zoom_out_vec:
				camera_2d.zoom = normal_zoom_vec
			
				
func on_game_over():
	FmodServer.set_global_parameter_by_name("Stage",2)
	if !debug:
		pause = true

func reset_tiles():
	tile_map_layer.position = Vector2.ZERO

func _process(delta: float) -> void:
	if !pause:
		var map_pos = starting_tile_position - Vector2i(0,1)
		update_y.emit(map_pos.y)
	
		starting_tile_position = map_pos 

		var converted = tile_map_layer.map_to_local(map_pos)/speed_inc_val
		if map_pos.y%110 == 0:
			place_obstacle(map_pos/speed_inc_val)
		if map_pos.y%500 == 0:
			place_powerup(map_pos/speed_inc_val)


		obstacle_tiles.global_position = converted


func place_powerup(map_pos):
	var center_marker = obstacle_tiles.local_to_map(%Marker2D.global_position) - Vector2i(map_pos)
	
	var power_up_arr = power_up_loot_table.item_results
	
	
	var random_x = randi_range(-30,30)
	if power_up_arr.size() > 0:
		var proper_power :Item = power_up_arr[0]
		var power_up_pos = center_marker - Vector2i(random_x,-80)
		power_up_pos = Vector2i(power_up_pos.x, abs(power_up_pos.y))
		obstacle_tiles.set_cell(power_up_pos, 5,Vector2.ZERO,proper_power.alternative_tile_id)
		
func place_obstacle(map_pos):
	
	var center_marker = obstacle_tiles.local_to_map(%Marker2D.global_position) - Vector2i(map_pos)
	
	var obstacles_arr = obstacle_loot_table.item_results
	if obstacles_arr.size() > 0:
		var proper_obstacle :Item = obstacles_arr[0]
		var obstacle_pos = center_marker - Vector2i(0,-80)
		obstacle_pos = Vector2i(obstacle_pos.x, abs(obstacle_pos.y))
		obstacle_tiles.set_cell(obstacle_pos, 4,Vector2.ZERO,proper_obstacle.alternative_tile_id)
	else:
		push_error("obstacle arr empty loot object")
