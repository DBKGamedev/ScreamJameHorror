extends Node2D

const IG_PICKUP_KNIFE_SFX = preload("res://assets/SFX/IG_pickup_knife_sfx.wav")

func _ready() -> void:
	if GlobalData.got_knife:
		queue_free()

func on_pick_up() -> void:
	AudioManager.play_sfx(IG_PICKUP_KNIFE_SFX, -2)
	visible = false
	GlobalData.got_knife = true
