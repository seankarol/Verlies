class_name MonsterType
extends Resource

@export var texture: Texture2D
@export_range(1, 100, 1, "or_greater") var max_health: int = 1
@export_range(1, 100, 1, "or_greater") var move_speed: float = 20.0
@export_range(1, 100, 1, "or_greater") var acceleration: float = 5.0
@export_range(1, 100, 1, "or_greater") var mass: float = 1.0
@export var weapon_scene: PackedScene
