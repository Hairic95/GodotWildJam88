extends Node



var dash = 100

signal on_dash_changed(dash)

enum States {MainMenu, Game}

var starting_state = States.MainMenu
var player_speed = 0

var speed = 4000
var real_speed_value = speed
var tile_size : Vector2 = Vector2(-274,-119)

signal gameOver
signal set_game_state(state: States)
signal stauts_complete(status:StatusEffect)
signal change_speed_amount
signal decrease_frost(amount)
signal change_map_speed_(new_val)

func _ready() -> void:
	#gameOver
	gameOver.connect(stop_game)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()

func change_state_to(state : States):
	starting_state = state
	set_state()
	
func reset_values():
	speed = 4000
	real_speed_value = speed
	player_speed = 0

func stop_game():
	speed = 0

func change_speed(amount):
	change_map_speed(amount)
	var new_speed = clampi(player_speed + amount, -4, 4)
	player_speed = new_speed
	change_speed_amount.emit()
	
func change_map_speed(amount):
	var new_speed = ( amount * 250) + real_speed_value
	new_speed = clampi(new_speed, 3000, 5000)
	real_speed_value = new_speed
	print("new speed ", new_speed)
	var tween = get_tree().create_tween()
	tween.tween_property(self,"speed", new_speed, 0.5).set_ease(Tween.EASE_IN_OUT)
	tween.tween_callback(on_tween_finished)
	change_map_speed_.emit(new_speed)

func on_tween_finished():
	pass

func set_state():
	match(starting_state):
		States.MainMenu:
			set_game_state.emit(States.MainMenu)
		States.Game:
			set_game_state.emit(States.Game)

func start_dashing(delta):
	
	dash -= delta * 50

	on_dash_changed.emit(dash)


func dash_cooldown(_delta):
	dash += _delta * 40
	on_dash_changed.emit(dash)


	
