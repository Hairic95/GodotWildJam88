extends CanvasLayer

@export var obstacle_node : Node2D
@export var debug_on : bool

@onready var scenes_amount_label: Label = %ScenesAmountLabel
@onready var all_entities_label: Label = %AllEntitiesLabel


func _process(delta: float) -> void:
	if debug_on:
		scenes_amount_label.text = str(obstacle_node.get_child_count())
		all_entities_label
