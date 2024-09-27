extends Node2D

func _physics_process(_delta: float) -> void:
	var avg_position: Vector2 = Vector2.ZERO
	var count: int = 0
	for player: Player in get_tree().get_nodes_in_group(&"Player"):
		avg_position += player.position
		count += 1
	
	if count > 0:
		avg_position = avg_position / count
		position = avg_position
