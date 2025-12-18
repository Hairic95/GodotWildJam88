extends Node

signal gameOver

var dash = 100

signal on_dash_changed(dash)

enum States {MainMenu, Game}

var starting_state = States.MainMenu

signal set_game_state(state: States)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()

func change_state_to(state : States):
	starting_state = state
	set_state()
	

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

func return_proper_obstacle(obs_arr, amount):
	pass
	
