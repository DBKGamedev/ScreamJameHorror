extends Area2D

signal interacted

@export var interact_name : String = ""
@export var is_interactable : bool = true

func interact() -> void:
	interacted.emit()
