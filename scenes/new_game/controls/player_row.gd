class_name NewGamePlayerRow
extends HBoxContainer

signal leave_pressed()

@export var input_map: PlayerInputMap:
	set = set_input_map

@onready var _label: Label = $Label

func _ready() -> void:
	set_input_map(input_map)


func set_input_map(value: PlayerInputMap) -> void:
	input_map = value
	
	if _label:
		_label.text = input_map.name


func _on_leave_button_pressed() -> void:
	leave_pressed.emit()
