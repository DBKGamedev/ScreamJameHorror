extends StaticBody2D

@onready var jumpscare: Node2D = $CanvasLayer/Control/Jumpscare
@onready var animation_player: AnimationPlayer = $CanvasLayer/Control/Jumpscare/AnimationPlayer
const ROOM_1 = preload("res://scenes/Rooms/room_1.tscn")

func scare() -> void:
	AudioManager.stop()
	jumpscare.show()
	animation_player.play("scare")
	await animation_player.animation_finished
	get_tree().change_scene_to_packed(ROOM_1)
	AudioManager.play("Music_1")
	GlobalData.reset()
