class_name WeaponRanged
extends Weapon

@onready var _sprite: Sprite2D = $Sprite2D
@onready var _animations: AnimationPlayer = $Sprite2D/AnimationPlayer

@export var turn_speed: float = 1.0
@export var projectile_scene: PackedScene

func attack() -> void:
	_animations.play(&"attack")


func is_attacking() -> bool:
	return _animations.is_playing()


func rotate_to(target: Vector2) -> void:
	var target_look: float = Vector2.ZERO.angle_to_point(target)
	rotation = wrap(rotate_toward(rotation, target_look, turn_speed), 0, PI * 2)
	_sprite.scale.y = -1 if is_facing_left() else 1


func is_facing_left() -> bool:
	return rotation > PI /2 and rotation < PI / 2 + PI


func fire() -> void:
	var projectile: Node2D = projectile_scene.instantiate()
	projectile.position = global_position
	projectile.rotation = rotation
	projectile.collision_mask = collision_mask
	Events.add_node_to_map.emit(projectile)
