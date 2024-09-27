extends Node2D

@onready var _restart_timer: Timer = $RestartTimer
@onready var _wave_timer: Timer = $WaveTimer

@export var player_scene: PackedScene
@export var monster_scene: PackedScene
@export var pickup_scene: PackedScene

enum State {
	PLAYING,
	GAME_OVER,
}

var _score: int = 0:
	set = _set_score
var _state: State = State.PLAYING
var _current_wave: int = 0
var _player_count: int = 0

func _init() -> void:
	Input.set_custom_mouse_cursor(null)


func _ready() -> void:
	Input.set_default_cursor_shape(Input.CursorShape.CURSOR_CROSS)
	
	var index: int = 1
	for input_map: PlayerInputMap in GameState.player_maps:
		var spawn: Node2D = get_tree().get_first_node_in_group("PlayerSpawn%s" % index)
		var player: Player = player_scene.instantiate()
		player.input_map = input_map
		player.position = spawn.position
		Events.add_node_to_map.emit(player)
		_player_count += 1
		index += 1
	
	Events.game_started.emit()
	Events.slime_died.connect(_on_events_slime_died)


func _process(_delta: float) -> void:
	if get_tree().get_nodes_in_group(&"Player").size() == 0 and _restart_timer.is_stopped():
		_state = State.GAME_OVER
		_restart_timer.start()
		Events.game_over.emit()
		Events.set_paused(false)

	if _state == State.PLAYING:
		if Input.is_action_just_pressed(&"pause"):
			Events.set_paused(not get_tree().paused)
		
		if not get_tree().paused:
			pass


func _spawn_wave() -> void:
	_wave_timer.start(max(15 - _current_wave, 5))
	_current_wave += 1
	
	var spawners: Array[Node] = get_tree().get_nodes_in_group(&"MonsterSpawner")
	for count: int in min(_current_wave * get_difficulty(), spawners.size() - 1):
		if spawners.is_empty():
			break
		
		var spawner: Marker2D = spawners.pick_random()
		spawners.erase(spawner)
		
		var monster: Monster = monster_scene.instantiate()
		monster.type = _get_monster_type()
		monster.position = spawner.position
		Events.add_node_to_map.emit(monster)
	
	if randi_range(0, 100) < 50:
		var pickup: Node2D = pickup_scene.instantiate()
		pickup.position = get_tree().get_nodes_in_group(&"PickupSpawner").pick_random().position
		Events.add_node_to_map.emit(pickup)


func get_difficulty() -> float:
	return _player_count


func _get_monster_type() -> MonsterType:
	return load([
		"res://resources/monster_types/slime.tres",
		"res://resources/monster_types/slime.tres",
		"res://resources/monster_types/slime.tres",
		"res://resources/monster_types/slime.tres",
		"res://resources/monster_types/slime.tres",
		"res://resources/monster_types/slime_fast.tres",
		"res://resources/monster_types/slime_fast.tres",
		"res://resources/monster_types/slime_fast.tres",
		"res://resources/monster_types/skeleton_melee.tres",
		"res://resources/monster_types/skeleton_melee.tres",
		"res://resources/monster_types/skeleton_ranged.tres",
	].pick_random())


func _on_events_slime_died() -> void:
	_score += 1


func _set_score(value: int) -> void:
	_score = value
	Events.score_changed.emit(_score)


func _on_restart_timer_timeout() -> void:
	get_tree().reload_current_scene()


func _on_start_timer_timeout() -> void:
	_spawn_wave()


func _on_wave_timer_timeout() -> void:
	_spawn_wave()
