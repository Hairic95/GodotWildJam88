@tool
extends Resource
class_name LootObject

#The chance for this item to drop
var probability:  float 

#Only drops once per query
@export var unique: bool 

#Drops always
@export var always : bool

@export var enabled : bool = true

enum Rarity {Basic, Uncommon, Rare, Omega}
@export var rarity : Rarity

func set_up():
	match(rarity):
		Rarity.Basic:
			probability = 10.0
		Rarity.Uncommon:
			probability = 5.0
		Rarity.Rare:
			probability = 0.5
		Rarity.Omega:
			probability = 0.1
