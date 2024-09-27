extends Node

@warning_ignore("unused_signal")
signal add_node_to_map(node: Node2D)

@warning_ignore("unused_signal")
signal paused_toggled(value: bool)

@warning_ignore("unused_signal")
signal slime_died()

@warning_ignore("unused_signal")
signal score_changed(value: int)

@warning_ignore("unused_signal")
signal game_started()

@warning_ignore("unused_signal")
signal game_over()

func set_paused(value: bool) -> void:
	get_tree().paused = value
	Events.paused_toggled.emit(value)
