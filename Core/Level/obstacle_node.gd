extends Node2D

@export var power_up_spawn_timer : Timer
@export var obstacle_spawn_timer : Timer

@onready var line_2d: Line2D = %Line2D

@onready var spawn_points : PackedVector2Array = line_2d.points

var entities = 0

var PACKAGE_BASE_SCENE = preload("uid://dw87sxiqvtey2")

@export var POWER_UP_LOOT_TABLE : LootTable

const HEAL_POWER_UP = preload("uid://qoco88rr8v17")
const SHIELD_POWER_UP = preload("uid://drekf23qslcg")
const SPEED_POWER_UP = preload("uid://db3jbxtm7jia0")
const WARM_POWER_UP = preload("uid://b038xil7kovth")

@export var OBSTACLE_UP_LOOT_TABLE : LootTable

const TREE = preload("uid://ce3oehf3dmi37")


var package_dictionary = {
	"PowerUp" = [
		HEAL_POWER_UP, 
		SHIELD_POWER_UP, 
		SPEED_POWER_UP, 
		WARM_POWER_UP]
		,
	"Obstacle" = [
		TREE
	]
}

func _ready() -> void:
	power_up_spawn_timer.timeout.connect(on_power_up_spawn)
	obstacle_spawn_timer.timeout.connect(on_obstacle_spawn)
	child_entered_tree.connect(on_package_enter_tree)


func on_obstacle_spawn():
	print("spawning")
	var obstacle_arr = OBSTACLE_UP_LOOT_TABLE.item_results
	if obstacle_arr.size() > 0:
		var obstacle = obstacle_arr[0]
		if obstacle is Obstacle:
			spawn_object("Obstacle", obstacle)

func on_power_up_spawn():
	var power_up_arr  = POWER_UP_LOOT_TABLE.item_results
	if power_up_arr.size() > 0:
		var power_up = power_up_arr[0]
		if power_up is PowerUp:
			spawn_object("PowerUp", power_up)

func spawn_object(dict_key, package_resource):
	var object_node_scene : PackedScene = package_dictionary[dict_key][package_resource.array_ind] 
	var power_up_node : PackageNode  = object_node_scene.instantiate()
	add_child(power_up_node)
	var random_point = spawn_points.get(randi()%spawn_points.size())
	power_up_node.global_position = random_point



func on_package_enter_tree(node: Node):
	pass
