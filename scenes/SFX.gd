extends AudioStreamPlayer
class_name SFX

var start_pos: float = 0.0

func _enter_tree() -> void:
	finished.connect(self.queue_free)

func _ready() -> void:
	play(start_pos)
