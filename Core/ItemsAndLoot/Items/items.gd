extends LootObject
class_name Item

enum item_types {buff, debuff, obstacle_pattern}

@export var item_name : String
@export var description : String
@export var item_type : item_types

@export var alternative_tile_id : int
