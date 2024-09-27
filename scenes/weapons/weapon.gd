class_name Weapon
extends Node2D

@export_flags_2d_physics var collision_mask: int

func attack() -> void:
	pass


func is_attacking() -> bool:
	return false


func rotate_to(_target: Vector2) -> void:
	pass


func is_facing_left() -> bool:
	return false
