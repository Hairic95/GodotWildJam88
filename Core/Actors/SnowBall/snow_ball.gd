extends Area2D

func _process(delta: float) -> void:
	scale+= Vector2(delta/100, delta/100)
