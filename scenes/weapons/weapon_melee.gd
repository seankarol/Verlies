class_name WeaponMelee
extends Weapon

@onready var _sprite: Sprite2D = $Sprite2D
@onready var _animations: AnimationPlayer = $Sprite2D/AnimationPlayer
@onready var _hurtbox: Area2D = $Sprite2D/HurtboxArea2D

@export var push: float = 200.0
@export var turn_speed: float = 1.0

func _ready() -> void:
	_hurtbox.collision_mask = collision_mask
	_hurtbox.pusher = get_parent()


func attack() -> void:
	if is_facing_left():
		_animations.play(&"attack_left")
	else:
		_animations.play(&"attack_right")


func is_attacking() -> bool:
	return _animations.is_playing()


func rotate_to(target: Vector2) -> void:
	var target_look: float = Vector2.ZERO.angle_to_point(target)
	rotation = wrap(rotate_toward(rotation, target_look, turn_speed), 0, PI * 2)
	_sprite.scale.y = -1 if is_facing_left() else 1


func is_facing_left() -> bool:
	return rotation > PI /2 and rotation < PI / 2 + PI
