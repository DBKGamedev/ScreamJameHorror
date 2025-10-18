extends StaticBody2D

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

var _cutable: bool = false

func _enter_tree() -> void:
	SignalBus.picked_up_knife.connect(func(): _cutable = true)

func thorns_cut() -> void:
	if _cutable:
		visible = false
		collision_shape_2d.disabled = true
