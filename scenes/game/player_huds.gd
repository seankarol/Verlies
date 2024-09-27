extends Control

func _ready() -> void:
	Events.game_started.connect(_on_events_game_started)


func _on_events_game_started() -> void:
	var count = 0
	for player: Player in get_tree().get_nodes_in_group(&"Player"):
		var texture: TextureRect = TextureRect.new()
		player.health_changed.connect(_on_player_health_changed.bind(texture))
		texture.expand_mode = TextureRect.EXPAND_KEEP_SIZE
		texture.stretch_mode = TextureRect.STRETCH_TILE
		if count == 0:
			texture.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN + Control.SIZE_EXPAND
		else:
			texture.size_flags_horizontal = Control.SIZE_SHRINK_END + Control.SIZE_EXPAND
		texture.texture = preload("res://scenes/game/heart.png")
		texture.custom_minimum_size = Vector2i(texture.texture.get_width() * player.health, texture.texture.get_height())
		add_child(texture)
		count += 1


func _on_player_health_changed(value: int, texture: TextureRect) -> void:
	texture.custom_minimum_size.x = texture.texture.get_width() * value
	texture.visible = value > 0
