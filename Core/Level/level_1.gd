extends Node2D

@export var pause : bool = false
@export var debug: bool = false
@export var obstacle_loot_table : LootTable
@export var power_up_loot_table : LootTable
@export var folliage_loot_table : LootTable

# this is stationary
@onready var ground_tile_layer: TileMapLayer = $GroundTiles

#this is moving, it spawns obstacles and power ups
@onready var obstacle_tile_layer: TileMapLayer = $ObstacleTiles
@onready var ui: CanvasLayer = $UI
@onready var camera_2d: Camera2D = $Camera2D
@onready var sprite_1: AnimatedSprite2D = $AvalanchePath2D3/AvalanchePathFollow2D/Avalache/Sprite1
@onready var sprite_2: AnimatedSprite2D = $AvalanchePath2D3/AvalanchePathFollow2D/Avalache/Sprite2
@onready var anim: AnimationPlayer = $AvalanchePath2D3/AvalanchePathFollow2D/Avalache/Anim

var player_position
var starting_tile_position : Vector2i= Vector2i.ZERO

signal update_y(y)

var speed_dictionary = {
	-4: 0.2,
	-3: 0.2,
	-2: 0.2,
	-1: 0.2,
	0: 0.2,
	1: 0.2,
	2: 0.2,
	3: 0.2,
	4: 0.2
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
	%GameSpeedTimer.timeout.connect(on_timer_timeout)

func on_timer_timeout():
	for key in speed_dictionary.keys():
		speed_dictionary[key] = speed_dictionary[key] 
	on_change_speed()

func on_change_speed():
	call_deferred("alter_speed")

func alter_speed():
	var new_val = speed_dictionary[GameState.player_speed]
	var tween = get_tree().create_tween()
	tween.tween_property(self, "speed_inc_val",new_val, 2.0).set_ease(Tween.EASE_IN_OUT)
	
func on_set_game_state(state: GameState.States):
	match(state):
		GameState.States.MainMenu:
			pause = true
			ui.hide()
			camera_2d.enabled = false
			
		GameState.States.Game:
			%GameSpeedTimer.start()
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
	ground_tile_layer.position = Vector2.ZERO

func _physics_process(delta: float) -> void:

	if !pause:
		var next_tile_position : Vector2i = next_tile_pos()
		var global_obstacle_tile_position = obstacle_tile_layer.map_to_local(next_tile_pos())
		
		
		#ground remains at pos : Vector2(0,0)
		var offset_obstacle_position = global_obstacle_tile_position 
		
		

func next_tile_pos() -> Vector2i:
	var tile_change_tick :Vector2i = Vector2i(0,1)
	var next_obstacle_map_position = starting_tile_position - tile_change_tick
	return next_obstacle_map_position

func place_powerup(map_pos):
	var center_marker = (%Marker2D.global_position) - Vector2i(map_pos)
	
	var power_up_arr = power_up_loot_table.item_results
	
	var random_x = randi_range(-30,30)
	if power_up_arr.size() > 0:
		var proper_power :Item = power_up_arr[0]
		var power_up_pos = center_marker - Vector2i(random_x,-400)
		power_up_pos = Vector2i(power_up_pos.x, abs(power_up_pos.y))
		obstacle_tile_layer.set_cell(power_up_pos, 5,Vector2.ZERO,proper_power.alternative_tile_id)
		
func place_obstacle(converted):

	var map = obstacle_tile_layer.local_to_map(%Marker2D.global_position)
	print("map markerpos ", map)
	
	var obstacles_arr = obstacle_loot_table.item_results
	if obstacles_arr.size() > 0:
		var proper_obstacle :Item = obstacles_arr[0]
		var obstacle_pos = map - Vector2i(0,-500)
		obstacle_pos = Vector2i(obstacle_pos.x, abs(obstacle_pos.y))
		obstacle_tile_layer.set_cell(obstacle_pos, 4,Vector2.ZERO,proper_obstacle.alternative_tile_id)
	else:
		push_error("obstacle arr empty loot object")

func place_trees(map_pos):
	
	var center_marker = (%Marker2D.global_position) - Vector2i(map_pos)
	var folliage_arr = folliage_loot_table.item_results
	
	var x1 = -50
	var x2 = 55
	if folliage_arr.size() > 1:
		var proper_folliage1 :Item = folliage_arr[0]
		var proper_folliage2 :Item = folliage_arr[1]
		
		var folliage_pos = center_marker - Vector2i(x1,-700)
		folliage_pos = Vector2i(folliage_pos.x, abs(folliage_pos.y))
		
		var folliage_pos_2 = center_marker - Vector2i(x2,-700)
		folliage_pos_2 = Vector2i(folliage_pos_2.x, abs(folliage_pos_2.y))
		
		obstacle_tile_layer.set_cell(folliage_pos, 16,Vector2.ZERO,proper_folliage1.alternative_tile_id)
		obstacle_tile_layer.set_cell(folliage_pos_2, 16,Vector2.ZERO,proper_folliage2.alternative_tile_id)
	else:
		push_error("obstacle arr empty loot object")
	
