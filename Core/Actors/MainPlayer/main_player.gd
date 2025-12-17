extends CharacterBody2D

@export var sledge: Node2D

@export var path : Path2D
@export var path_follow : PathFollow2D
var speed = 20
@onready var health_manager: HealthManager = $HealthManager
@onready var hitbox: Area2D = $Hitbox
signal take_dmg
var jumping = false

var speed_pos_0 = Vector2(-697.0, -286.0)
var speed_pos_1= Vector2(-337.0, 73.0)
var speed_pos_2= Vector2(322.0, 733.0)

var speed_pos = 0

const PLAYER_COLLISION_SHAPE = preload("uid://lhbpgu1bpmcw")

var jump_height = 550

func _ready() -> void:
	path.global_position = speed_pos_0
	health_manager.took_damage.connect(on_take_dmg)
	hitbox.increase_speed.connect(on_increase_speed)

func on_increase_speed(amount):
	var new_path_pos = Vector2.ZERO
	if amount > 0 and speed_pos != 2:
		speed_pos += 1
		match(speed_pos):
			1:
				new_path_pos = speed_pos_1
			2:
				new_path_pos = speed_pos_2
	if amount < 0 and speed_pos != 0:
		speed_pos -= 1
		match(speed_pos):
			0:
				new_path_pos = speed_pos_0
			1:
				new_path_pos = speed_pos_1
	if new_path_pos != Vector2.ZERO:
		path.global_position= new_path_pos
		




func on_take_dmg(amount):
	take_dmg.emit(amount)
	print("took %s dmg"%[amount])

func _process(_delta: float) -> void:
	var direction = Input.get_vector("ui_left", "ui_right",  "ui_down", "ui_up")
	if direction:
		if direction.x != 0:
			path_follow.progress += (speed * direction.x)
			if direction.x > 0:
				if sledge:
					sledge.change_frame(2)
			elif direction.x < 0:
				if sledge:
					sledge.change_frame(0)
		else:
				sledge.change_frame(1)
	else:
			sledge.change_frame(1)
		#if direction.y != 0:
			#
			#path.global_position = path.global_position - Vector2(direction.y,direction.y) * speed
			#print(path.global_position)

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_accept") and !jumping:
		jump()
	
func jump():
	delete_collision()
	jumping = true
	var tween = get_tree().create_tween()

	await tween.tween_property(self, "position", Vector2(jump_height,-jump_height), 0.3).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUINT).finished
	
	var tween2 = get_tree().create_tween()
	
	await tween2.tween_property(self, "position", Vector2(0,0), 0.4).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_BOUNCE).finished
	replace_collision()
	jumping = false
	

func replace_collision():
	var col = PLAYER_COLLISION_SHAPE.instantiate()
	hitbox.add_child(col)

func delete_collision():
	for child in hitbox.get_children():
		if child is CollisionShape2D:
			child.queue_free()
	

	
		
	
