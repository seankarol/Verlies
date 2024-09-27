extends Label

func _ready() -> void:
	visible = false
	Events.game_over.connect(_on_game_over)


func _on_game_over() -> void:
	visible = true
