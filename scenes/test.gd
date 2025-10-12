extends Node2D

@onready var interactable: Area2D = $interactable

func _on_interactable_interacted() -> void:
	print("interacted")
