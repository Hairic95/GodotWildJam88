extends Node2D
@onready var tile_map_layer: TileMapLayer = $GroundTiles
@onready var obstacle_tiles: TileMapLayer = $ObstacleTiles

@export var pause : bool = false
var speed = 30
var player_position

func _process(delta: float) -> void:
	if !pause:
		tile_map_layer.position = tile_map_layer.position - Vector2(1,1) * speed
		obstacle_tiles.position = tile_map_layer.position- Vector2(1,1) * speed



	
