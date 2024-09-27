extends TileMapLayer

func _ready() -> void:
	Events.add_node_to_map.connect(_on_events_add_node_to_map)


func _on_events_add_node_to_map(node: Node2D) -> void:
	add_child(node)
