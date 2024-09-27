class_name HurtboxArea2D
extends Area2D

signal hit()

@export var enabled: bool = true
@export_range(0, 1000, 0, "or_greater") var push: float = 0.0
@export var pusher: Node2D

func _physics_process(_delta: float) -> void:
	if enabled:
		for body: Node2D in get_overlapping_bodies():
			if body.has_method(&"hit"):
				if body.hit(pusher if pusher else self, push):
					hit.emit()
			else:
				hit.emit()
