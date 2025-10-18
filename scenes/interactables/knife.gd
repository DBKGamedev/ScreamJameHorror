extends Node2D

func on_pick_up() -> void:
	print("got knife")
	SignalBus.picked_up_knife.emit()
	visible = false
