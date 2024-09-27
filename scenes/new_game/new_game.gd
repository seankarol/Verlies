extends Control

@export var input_maps: Array[PlayerInputMap] = []

@onready var _player_container: Control = %PlayerContainer
@onready var _start_button: Button = %StartButton

func _ready() -> void:
	_start_button.grab_focus()
	
	Input.set_default_cursor_shape(Input.CursorShape.CURSOR_ARROW)
	
	GameState.reset_players()
	GameState.player_added.connect(_on_game_state_player_added)
	GameState.player_added.connect(_on_game_state_player_removed)


func _process(_delta: float) -> void:
	if GameState.player_maps.size() < 2:
		for input_map: PlayerInputMap in input_maps:
			if Input.is_action_just_pressed(input_map.start):
				if GameState.add_player(input_map):
					var player_row: NewGamePlayerRow = preload("res://scenes/new_game/controls/player_row.tscn").instantiate()
					player_row.input_map = input_map
					player_row.leave_pressed.connect(_on_player_row_leave_pressed.bind(player_row, input_map))
					_player_container.add_child(player_row)
	

func _on_start_button_pressed() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	get_tree().change_scene_to_file("res://scenes/game/game.tscn")


func _on_player_row_leave_pressed(player_row: NewGamePlayerRow, input_map: PlayerInputMap) -> void:
	if GameState.remove_player(input_map):
		player_row.queue_free()


func _on_game_state_player_added(_input_map: PlayerInputMap) -> void:
	_start_button.disabled = false


func _on_game_state_player_removed(_input_map: PlayerInputMap) -> void:
	_start_button.disabled = GameState.player_maps.is_empty()
