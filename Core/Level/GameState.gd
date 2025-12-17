extends Node

signal gameOver

var dash = 100

signal on_dash_changed(dash)


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()


func start_dashing(delta):
	
	dash -= delta * 50
	print(dash)
	on_dash_changed.emit(dash)


func dash_cooldown(_delta):
	dash += _delta * 40
	print(dash)
	on_dash_changed.emit(dash)
