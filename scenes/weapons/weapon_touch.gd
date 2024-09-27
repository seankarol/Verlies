class_name WeaponTouch
extends Weapon

@onready var _hurtbox: Area2D = $HurtboxArea2D

@export var enabled: bool = true:
	set = set_enabled

func _ready() -> void:
	_hurtbox.collision_mask = collision_mask
	_hurtbox.enabled = enabled


func is_attacking() -> bool:
	return enabled


func set_enabled(value: bool) -> void:
	enabled = value
	
	if _hurtbox:
		_hurtbox.enabled = enabled
