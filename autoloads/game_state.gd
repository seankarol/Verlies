extends Node

const MAX_PLAYERS: int = 2

signal player_added(input_map: PlayerInputMap)
signal player_removed(input_map: PlayerInputMap)

@export var player_maps: Array[PlayerInputMap] = []

func reset_players() -> void:
	player_maps = []


func add_player(input_map: PlayerInputMap) -> bool:
	if not player_maps.has(input_map) and player_maps.size() < MAX_PLAYERS:
		player_maps.push_back(input_map)
		player_added.emit(input_map)
		return true
	return false


func remove_player(input_map: PlayerInputMap) -> bool:
	if player_maps.has(input_map):
		player_maps.erase(input_map)
		player_removed.emit(input_map)
		return true
	return false
