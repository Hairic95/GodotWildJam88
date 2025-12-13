extends Node2D
@onready var tile_map_layer: TileMapLayer = $GroundTiles
@onready var obstacle_tiles: TileMapLayer = $ObstacleTiles

@export var pause : bool = false
var speed = 30
var player_position

func _ready() -> void:
	GameState.gameOver.connect(on_game_over)

func on_game_over():
	pause = true

func _process(delta: float) -> void:
	if !pause:
		tile_map_layer.position = tile_map_layer.position - Vector2(1,1) * speed
		obstacle_tiles.position = tile_map_layer.position- Vector2(1,1) * speed



	
