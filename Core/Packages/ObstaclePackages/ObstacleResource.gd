extends Package
class_name Obstacle

@export var damage : int = 10
@export var random_scale  : Vector2 = Vector2(4,5)

enum ObstacleTypes {PineTree, Rock, Fence, Yeti}
@export var obstacle_type : ObstacleTypes

enum Materials {Wood, Stone, Metal}
@export var material_type : Materials

const TREE_1 = preload("uid://dyvqp112xt05k")
const TREE_2 = preload("uid://b82ahn1r7ofpb")

const ACTUAL_ROCK = preload("uid://dstdu8701nytv")
const ACTUAL_ROCK_2 = preload("uid://csh62bdmixid7")
const ACTUAL_ROCK_3 = preload("uid://dx0anbuoonb2d")

const FENCE = preload("uid://yy6oll5h0nya")


func choose_random_text():
	match(obstacle_type):
		ObstacleTypes.Rock:
			match(randi()%3):
				1:
					return ACTUAL_ROCK
				2:
					return ACTUAL_ROCK_2
				0:
					return ACTUAL_ROCK_3
		ObstacleTypes.PineTree:
			match(randi()%2):
				0:
					return TREE_1
				1:
					return TREE_2
		ObstacleTypes.Fence:
			return FENCE

func return_random_scale():
	if random_scale:
		var random = randf_range(random_scale.x, random_scale.y)
		return Vector2(random, random)

			

			
	
