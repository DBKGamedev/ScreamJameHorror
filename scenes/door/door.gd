extends Node2D
class_name Door

@export  var destination_scene_tag: String
@export var destination_door_tag: String
@export var spawn_dir: String = "up"
@export var audio_stream: AudioStream

@onready var spawn: Marker2D = $spawn


func _on_interactable_interacted() -> void:
	AudioManager.play_sfx(audio_stream, -8)
	NavigationManager.go_to_level(destination_scene_tag, destination_door_tag)
