extends Area2D

signal interacted

@export var is_interactable : bool = true

func interact() -> void:
	interacted.emit()
