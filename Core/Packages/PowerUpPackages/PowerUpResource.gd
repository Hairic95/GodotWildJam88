extends Package
class_name PowerUp

enum PowerUpTypes {None, Speed, Shield, Alcohol, WarmClothes, FirstAid, Lake, Mid}

@export var power_up_types : PowerUpTypes
@export var amount : int
