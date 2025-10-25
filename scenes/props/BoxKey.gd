extends StaticBody2D

const IG_PICKUP_KEY_SFX = preload("res://assets/SFX/IG_pickup_key_sfx.wav")

func key() -> void:
	AudioManager.play_sfx(IG_PICKUP_KEY_SFX, -2)
	GlobalData.got_key = true
