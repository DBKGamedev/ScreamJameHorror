extends StaticBody2D

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var dialogue_shape: CollisionShape2D = $DialogueMaker2/interactable/CollisionShape2D
@onready var dialogue_maker_2: DialogueMaker = $DialogueMaker2

const IG_KNIFESLASH_SFX_2 = preload("res://assets/SFX/IG_knifeslash_sfx_2.wav")


func _enter_tree() -> void:
	pass

func _ready() -> void:
	dialogue_shape.disabled = true

func on_interact() -> void:
	if GlobalData.got_knife:
		dialogue_shape.disabled = false

func thorns_cut() -> void:
	if GlobalData.got_knife:
		visible = false
		AudioManager.play_sfx(IG_KNIFESLASH_SFX_2, -2)
		collision_shape_2d.disabled = true
		await dialogue_maker_2.dialouge_finished_maker
		queue_free()
