extends Control

func _ready() -> void:
	Events.paused_toggled.connect(_on_events_paused_toggled)
	visible = false


func _on_events_paused_toggled(value: bool) -> void:
	visible = value
	if visible:
		for child: Control in get_children():
			if child.focus_mode != FocusMode.FOCUS_NONE:
				child.grab_focus()
				break


func _on_continue_button_pressed() -> void:
	Events.set_paused(false)


func _on_quit_to_menu_button_pressed() -> void:
	Events.set_paused(false)
	get_tree().change_scene_to_file("res://scenes/new_game/new_game.tscn")
