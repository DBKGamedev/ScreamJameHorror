extends Node2D

@onready var control: Control = $CanvasLayer/Control
@onready var jumpscare: Node2D = $CanvasLayer/Control/Jumpscare
@onready var animation_player: AnimationPlayer = $CanvasLayer/Control/Jumpscare/AnimationPlayer
const ROOM_1 = preload("res://scenes/Rooms/room_1.tscn")

var jumpscare_not_happened : bool = true

func _enter_tree() -> void:
	SignalBus.on_player_died.connect(start_jumpscare)

func _ready() -> void:
	AudioManager.play("Music_2")

func start_jumpscare() -> void:
	if jumpscare_not_happened:
		AudioManager.stop()
		jumpscare_not_happened = false
		jumpscare.show()
		animation_player.play("scare")
		await animation_player.animation_finished
		get_tree().change_scene_to_packed(ROOM_1)
		AudioManager.play("Music_1")
		GlobalData.reset()
