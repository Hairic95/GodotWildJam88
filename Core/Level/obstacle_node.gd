extends Node2D

@export var power_up_spawn_timer : Timer
@export var obstacle_spawn_timer : Timer
@export var obstacle_pattern_spawn_timer : Timer

@onready var line_2d: Line2D = %Line2D

@onready var spawn_points : PackedVector2Array = line_2d.points

var entities = 0

var PACKAGE_BASE_SCENE = preload("uid://dw87sxiqvtey2")

@export var POWER_UP_LOOT_TABLE : LootTable

const HEAL_POWER_UP = preload("uid://qoco88rr8v17")
const SHIELD_POWER_UP = preload("uid://drekf23qslcg")
const SPEED_POWER_UP = preload("uid://db3jbxtm7jia0")
const WARM_POWER_UP = preload("uid://b038xil7kovth")
const ALCOHOL_POWER_UP = preload("uid://v32vmxw56lpw")

@export var OBSTACLE_UP_LOOT_TABLE : LootTable

const TREE = preload("uid://ce3oehf3dmi37")
const FENCE_OBSTACLE = preload("uid://b3q0qfiim1xij")
const ROCK_OBSTACLE = preload("uid://c4kjvua2wp2q4")

@export var OBSTACLE_PATTERN_UP_LOOT_TABLE : LootTable

const OBSTACLE_PATTERN_FOREST = preload("uid://b47rksibvsuiy")
const DRUNK_FOREST_OBSTACLE_PATTERN = preload("uid://cx0brrstrxfd")
const MIDDLE_FENCE_OBSTACLE_PATTERN_NODE = preload("uid://b0ou5vmweaq3p")
const RIGHT_FENCE_OBSTACLE_PATTERN_NODE = preload("uid://pevi364ibsvw")
const YETI_OBSTACLE_PATTERN_NODE = preload("uid://brcfi8tcxhqym")
const CHILL_OBSTACLE_PATTERN_NODE = preload("uid://dx47bcxo70tn0")
const LOVE_FOREST_OBSTACLE_PATTERN_NODE = preload("uid://cphiht84cryqt")
const FENCE_ROCK_OBSTACLE_PATTERN_NODE = preload("uid://c3a7bg6vhaxiw")
const COOL_FENCE_OBSTACLE_PATTERN_NODE = preload("uid://dbln63d2ycp8u")
const ROCK_TREE_OBSTACLE_PATTERN_NODE = preload("uid://dskr3h3nkc1yf")


var package_dictionary = {
	"PowerUp" = [
		HEAL_POWER_UP, 
		SHIELD_POWER_UP, 
		SPEED_POWER_UP, 
		WARM_POWER_UP,
		ALCOHOL_POWER_UP
		]
		,
	"Obstacle" = [
		TREE,
		ROCK_OBSTACLE,
		FENCE_OBSTACLE
	],
	"ObstaclePattern" = [
		OBSTACLE_PATTERN_FOREST,
		DRUNK_FOREST_OBSTACLE_PATTERN,
		MIDDLE_FENCE_OBSTACLE_PATTERN_NODE,
		RIGHT_FENCE_OBSTACLE_PATTERN_NODE,
		YETI_OBSTACLE_PATTERN_NODE,
		CHILL_OBSTACLE_PATTERN_NODE, 
		LOVE_FOREST_OBSTACLE_PATTERN_NODE,
		FENCE_ROCK_OBSTACLE_PATTERN_NODE,
		COOL_FENCE_OBSTACLE_PATTERN_NODE,
		ROCK_TREE_OBSTACLE_PATTERN_NODE
	]
}

func _ready() -> void:
	power_up_spawn_timer.timeout.connect(on_power_up_spawn)
	obstacle_spawn_timer.timeout.connect(on_obstacle_spawn)
	obstacle_pattern_spawn_timer.timeout.connect(on_object_pattern_spawn)
	child_entered_tree.connect(on_package_enter_tree)

func start_timers():
	obstacle_pattern_spawn_timer.start()

func remove_children():
	for child in get_children():
		child.queue_free()

func on_object_pattern_spawn():
	var object_pattern_arr = OBSTACLE_PATTERN_UP_LOOT_TABLE.item_results
	if object_pattern_arr.size() > 0:
		var obstacle_pattern = object_pattern_arr[0]
		if obstacle_pattern is ObstaclePattern:
			spawn_object_pattern(obstacle_pattern)

func spawn_object_pattern(package_resource):
	var object_pattern_node_scene : PackedScene = package_dictionary["ObstaclePattern"][package_resource.array_ind] 
	var object_pattern_node : PackageBody  = object_pattern_node_scene.instantiate()
	add_child(object_pattern_node)
	object_pattern_node.global_position = %ObjectPatternMarker2D.global_position

func on_obstacle_spawn():
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
