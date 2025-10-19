extends StaticBody2D

@export var randomise: bool = false

func _ready() -> void:
	if randomise:
		play_randomized("strobe")

func play_randomized(Idle : String):
	randomize()
	$AnimationPlayer.play(Idle)
	var offset : float = randf_range(0, $AnimationPlayer.current_animation_length)
	$AnimationPlayer.advance(offset)
