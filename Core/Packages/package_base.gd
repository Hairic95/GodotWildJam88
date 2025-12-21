extends PackageBody
class_name PackageNode

@export var package_resource: Package

@onready var timer: Timer = $Timer
@onready var package_area: Area2D = $PackageArea
@onready var sprite_2d: Sprite2D = $Sprite2D

func _ready() -> void:
	timer.timeout.connect(kill)
	if package_resource.package_type == Package.PackageTypes.Obstacles:
		var text = package_resource.choose_random_text()
		scale = package_resource.return_random_scale()
		sprite_2d.texture = text

func kill():
	call_deferred("queue_free")
