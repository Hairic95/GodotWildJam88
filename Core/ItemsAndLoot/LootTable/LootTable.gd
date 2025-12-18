extends LootObject
class_name LootTable

#How many items shall drop from this table?
@export var item_drop_count : int   
#The contents of the table
@export var item_list : Array[LootObject]

var unique_drops : Array[LootObject] = []

var rng = RandomNumberGenerator.new()

var item_results : Array[LootObject]:
	get():
		init_objects()
		
		# this arr will contain the chosen loot items
		var item_result_arr : Array[LootObject]

		var always_count_arr = []
		#this is extracting the items that should always be in the result
		for items in item_list:
			if items.always and items.enabled:
				always_count_arr.append(items)
				add_to_result(item_result_arr, items)
		
		var always_count_size = always_count_arr.size()
		
		#subtracting the always count items by the amount of items we need to choose
		var real_drop_count = item_drop_count - always_count_size;

		if real_drop_count > 0:
			var dropables = []
			for loot_item in item_list:
				if loot_item.enabled and !loot_item.always and !unique_drops.has(loot_item):
					dropables.append(loot_item)
			
			var dropable_weight = []
			
			#filling an arr with just the item weights
			for dropable in dropables:
				dropable_weight.append(dropable.probability)
			
			for i in real_drop_count:
				var hit = dropables[rng.rand_weighted(dropable_weight)]
				add_to_result(item_result_arr, hit)
				
				#we are removing the items we've already retrieved
				var index = dropables.find(hit)
				if index != -1:
					dropables.remove_at(index)
					dropable_weight.remove_at(index)
					
		return item_result_arr

func init_objects():
	# initializing the probability so we can use enum to for our items
	for item : LootObject in item_list:
		item.set_up()

func add_to_result(item_result_arr : Array[LootObject], potentially_added_item : LootObject) -> void:
	
	# its potentially added because below we check if we will actually add
	# the item to the item_result_arr
	
	if !potentially_added_item.unique or !unique_drops.has(potentially_added_item):
		# if the item is unique we add it to global unique arr
		if (potentially_added_item.unique):
			unique_drops.append(potentially_added_item)
		
		if potentially_added_item != null:
			
			if potentially_added_item is LootTable: 
				item_result_arr.append_array(item_results)
			else:
				
				item_result_arr.append(potentially_added_item)
				
			
