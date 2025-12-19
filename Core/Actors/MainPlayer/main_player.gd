extends CharacterBody2D

@export var sledge: Node2D

@export var path : Path2D
@export var path_follow : PathFollow2D

@export var y_path_follow : PathFollow2D
var initial_speed = 20
var speed = initial_speed
var dash_speed = 80
@onready var health_manager: HealthManager = $HealthManager
@onready var hitbox: Area2D = $Hitbox
signal take_dmg
signal set_status_effect(status:StatusEffect)
var jumping = false
@onready var sprite_2d: AnimatedSprite2D = $Sprite2D

const PLAYER_COLLISION_SHAPE = preload("uid://lhbpgu1bpmcw")
var jump_height = 550
var crunk = false
const DRUNKENNESS = preload("uid://cnga3t5galdyp")

var initial_pos 

func _ready() -> void:
	#path.global_position=  Vector2(1470, -858)
	#path.global_position = speed_pos_0
	health_manager.took_damage.connect(on_take_dmg)
	health_manager.took_damage.connect(hit_flash)
	hitbox.increase_speed.connect(on_increase_speed)
	hitbox.get_crunk.connect(on_get_crunk)
	GameState.stauts_complete.connect(on_status_effect_end)
	initial_pos = position

func hit_flash(dmg):
	var tween : Tween = get_tree().create_tween()
	await tween.tween_property(sprite_2d, "material:shader_parameter/active",true, 0.3).set_ease(Tween.EASE_IN_OUT).finished
	var tween2 = get_tree().create_tween()
	tween2.tween_property(sprite_2d, "material:shader_parameter/active",false, 0.3)

func on_status_effect_end(status: StatusEffect):
	match(status):
		DRUNKENNESS:
			crunk = false

func on_get_crunk():
	crunk = true
	set_status_effect.emit(DRUNKENNESS)

func on_increase_speed(amount):
	GameState.change_speed(1)

func on_take_dmg(amount):
	GameState.change_speed(-1)
	take_dmg.emit(amount)
	
	

func _process(delta: float) -> void:
	var direction = Input.get_vector("ui_left", "ui_right",  "ui_down", "ui_up")
	var what_frame = $Sprite2D.frame
	if what_frame == 1:
		FmodServer.set_global_parameter_by_name("Turn",0)
	if direction:
		if crunk:
			direction.x = direction.x * -1
			
		if direction.x != 0:
			path_follow.progress += (speed * direction.x)
			if direction.x > 0:
				if sledge:
					sledge.change_frame(2)
					FmodServer.set_global_parameter_by_name("Turn",1)
			elif direction.x < 0:
				if sledge:
					sledge.change_frame(0)
					FmodServer.set_global_parameter_by_name("Turn",1)
	
		else:
			if sledge:
				sledge.change_frame(1)
				FmodServer.set_global_parameter_by_name("Turn",0)
		
		if direction.y != 0:
			print("progress ratio ", y_path_follow.progress_ratio)

			if direction.y >0:
				y_path_follow.progress -= (direction.y * speed)
			elif direction.y < 0:
				y_path_follow.progress -= (direction.y * speed)
	else:
		if sledge:
			sledge.change_frame(1)
		#if direction.y != 0:
			#
			#path.global_position = path.global_position - Vector2(direction.y,direction.y) * speed
		
	if Input.is_action_pressed("dash") and (GameState.dash > 0):
		dashing(delta)
	else:
		reduce_dash(delta)
	if Input.is_action_just_pressed("jump") and !jumping:
		jump()
	 
	$ShieldSprite.rotation_degrees += 100 * delta
	for child in $ShieldSprite.get_children():
		child.rotation_degrees -= 100 * delta
		
func reduce_dash(_delta):
	if GameState.dash < 100:
		speed = initial_speed
		GameState.dash_cooldown(_delta)
	
func dashing(_delta):
	if GameState.dash > 0:
		speed = dash_speed
		GameState.start_dashing(_delta)
	
func jump():

	delete_collision()
	jumping = true
	
	var tweensled = get_tree().create_tween()
	
	var sled_initial = sledge.position
	var jump_height_pos = sled_initial + Vector2(0,-550)
	
	tweensled.tween_property(sledge, "position",jump_height_pos, 0.3).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUINT)
	 
	var tween = get_tree().create_tween()
	await tween.tween_property(self, "position", Vector2(jump_height,-jump_height), 0.3).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUINT).finished
	
	var tweensled2 = get_tree().create_tween()
	tweensled2.tween_property(sledge, "position", sled_initial, 0.4).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_BOUNCE)
	
	var tween2 = get_tree().create_tween()
	await tween2.tween_property(self, "position", initial_pos, 0.4).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_BOUNCE).finished
	replace_collision()
	jumping = false


func replace_collision():
	var col = PLAYER_COLLISION_SHAPE.instantiate()
	hitbox.add_child(col)

func delete_collision():
	for child in hitbox.get_children():
		if child is CollisionShape2D:
			child.queue_free()
	

func get_leash_point():
	return $LeashPosition.global_position
