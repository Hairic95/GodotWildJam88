extends PackageBody
class_name PackageNode

@export var package_resource: Package
@onready var package_area: Area2D = $PackageArea
@onready var sprite_2d: Sprite2D = $Sprite2D

func _ready() -> void:
	
	if package_resource.package_type == Package.PackageTypes.Obstacles:
		var text = package_resource.choose_random_text()
		scale = package_resource.return_random_scale()
		sprite_2d.texture = text
