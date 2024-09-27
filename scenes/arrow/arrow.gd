extends Node2D

@onready var _hurtbox: HurtboxArea2D = $HurtboxArea2D

@export_flags_2d_physics var collision_mask: int
@export var speed: float = 100.0

func _ready() -> void:
	_hurtbox.collision_mask = 1 + collision_mask


func _physics_process(delta: float) -> void:
	position += Vector2(speed, 0).rotated(rotation) * delta


func _on_hurtbox_area_2d_hit() -> void:
	queue_free()
