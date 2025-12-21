extends Node2D

@export var pause : bool = false
@export var debug: bool = false

# this is stationary
@onready var ground_tile_layer: TileMapLayer = $GroundTiles
@onready var ui: CanvasLayer = $UI
@onready var camera_2d: Camera2D = $Camera2D
@onready var sprite_1: AnimatedSprite2D = $AvalanchePath2D3/AvalanchePathFollow2D/Avalache/Sprite1
@onready var sprite_2: AnimatedSprite2D = $AvalanchePath2D3/AvalanchePathFollow2D/Avalache/Sprite2
@onready var anim: AnimationPlayer = $AvalanchePath2D3/AvalanchePathFollow2D/Avalache/Anim
@onready var obstacle_node: Node2D = $SpawnNode/ObstacleNode

var player_position
var starting_tile_position : Vector2i= Vector2i.ZERO

signal update_y(y)

var score = 0

func _ready() -> void:
	GameState.gameOver.connect(on_game_over)
	GameState.reset_values()
	anim.play("Idle")
	sprite_1.play("idle")
	sprite_2.play("idle")
	GameState.set_game_state.connect(on_set_game_state)
	on_set_game_state(GameState.starting_state)
	#GameState.change_speed_amount.connect(on_change_speed)
	#%GameSpeedTimer.timeout.connect(on_timer_timeout)


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
			obstacle_node.start_timers()

func _process(delta: float) -> void:
	if !pause:
		score = score + delta * GameState.real_speed_value/1000
		update_y.emit(score)

func _input(_event: InputEvent) -> void:
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
		%ObjectPatternTimer.stop()
		obstacle_node.remove_children()
		pause = true

func reset_tiles():
	ground_tile_layer.position = Vector2.ZERO
