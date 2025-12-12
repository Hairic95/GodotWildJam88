extends Node2D
@onready var tile_map_layer: TileMapLayer = $ground

var speed = 50

func _process(delta: float) -> void:
	tile_map_layer.position = tile_map_layer.position - Vector2(1,1) * speed

func _input(event: InputEvent) -> void:
	pass
