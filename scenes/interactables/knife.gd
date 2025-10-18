extends Node2D

signal picked_up_knife

func on_pick_up() -> void:
	print("got knife")
	picked_up_knife.emit()
	visible = false
