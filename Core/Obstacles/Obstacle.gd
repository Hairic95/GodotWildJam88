extends Area2D
class_name Obstacle

var rock_texture_2 = preload("res://assets/textures/actual_rock_2.png")
var rock_texture_3 = preload("res://assets/textures/actual_rock_3.png")

@export var damage : int = 1

enum Materials {Wood, Stone, Metal}
@export var material_type : Materials

func _ready() -> void:
	if material_type == Materials.Stone:
		match(randi()%3):
			1:
				$Sprite2D.texture = rock_texture_2
			2:
				$Sprite2D.texture = rock_texture_3
			
