extends Label

func _ready() -> void:
	Events.score_changed.connect(_on_events_score_changed)
	text = "0"


func _on_events_score_changed(value: int) -> void:
	text = "%s" % value
