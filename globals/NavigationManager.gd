extends Node

const ROOM_1 = preload("res://scenes/Rooms/room_1.tscn")
const ROOM_2 = preload("res://scenes/Rooms/room_2.tscn")

var spawn_door_tag

signal on_triger_player_spawn

func go_to_level(level_tag: String, destination_tag: String) -> void:
	var _scene_to_load
	
	match level_tag:
		"room_1":
			_scene_to_load = ROOM_1
		
		"room_2":
			_scene_to_load = ROOM_2
		
		_:
			printerr("ERROR: MISSPELLED SCENE TAG")
	
	if _scene_to_load:
		spawn_door_tag = destination_tag
		get_tree().change_scene_to_packed(_scene_to_load)

func trigger_player_spawn(pos: Vector2, dir: String) -> void:
	on_triger_player_spawn.emit(pos, dir)
