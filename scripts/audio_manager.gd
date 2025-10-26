extends Node

var current_music: AudioStreamPlayer

@export var clips: Node
@export var sfx: Node
@export var sfx_scene: PackedScene

func _ready() -> void:
	AudioManager.play("Music_1")

func play(audio_name: String, start_pos: float = 0.0) -> void:
	if current_music:
		current_music.stop()
	current_music = clips.get_node(audio_name)
	current_music.play(start_pos)

func stop() -> void:
	current_music.stop()

func play_sfx(audio_stream: AudioStream, volume_DB: float = 0.0, start_pos: float = 0.0) -> SFX:
	var audio_one_shot: SFX = sfx_scene.instantiate()
	audio_one_shot.stream = audio_stream
	audio_one_shot.volume_db = volume_DB
	audio_one_shot.start_pos = start_pos
	
	sfx.add_child(audio_one_shot)
	return audio_one_shot
