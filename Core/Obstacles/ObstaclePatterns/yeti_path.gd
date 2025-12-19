extends Path2D

@onready var path_follow_2d: PathFollow2D = $PathFollow2D

func _process(delta: float) -> void:
	path_follow_2d.progress += delta * 10000
