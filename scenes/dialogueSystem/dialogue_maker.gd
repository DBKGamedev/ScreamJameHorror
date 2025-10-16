extends Node2D

const DIALOGUE_SYSTEM = preload("res://scenes/dialogueSystem/dialogue_system.tscn")

@export var activate_instant: bool
@export var only_activate_once: bool
@export var override_dialogue_position: bool
@export var override_position: Vector2
@export var dialouge: Array[DE]

@onready var interactable: Area2D = $interactable

var _dialogue_top_pos: Vector2 = Vector2(20, 48)
var _dialogue_bottom_pos: Vector2 = Vector2(20, 164)

var _player_body_in: bool = false
var _has_activated: bool = false
var _disired_dialogue_pos : Vector2

var _player: player

func _ready() -> void:
	for i in get_tree().get_nodes_in_group("Player"):
		_player = i

func _process(delta: float) -> void:
	if !_player:
		for i in get_tree().get_nodes_in_group("Player"):
			_player = i
		return

func _activate_dialoge() -> void:
	print("interacted")
	_player.can_move = false
	
	var Dialogue = DIALOGUE_SYSTEM.instantiate()
	if override_dialogue_position:
		_disired_dialogue_pos = override_position
	else:
	
		_disired_dialogue_pos = _dialogue_bottom_pos
	
	Dialogue.global_position = _disired_dialogue_pos
	Dialogue._dilogue = dialouge
	get_viewport().get_camera_2d().add_child(Dialogue)

func _on_interactable_interacted() -> void:
	if !activate_instant and _player_body_in:
		if only_activate_once and _has_activated:
			interactable.disconnect("interacted", _on_interactable_interacted)
			return
		
		_activate_dialoge()
		_player_body_in = false


func _on_interactable_body_entered(body: Node2D) -> void:
	if only_activate_once and _has_activated:
		return
	if body is player:

		_player_body_in = true
		if activate_instant:
			_activate_dialoge()


func _on_interactable_body_exited(body: Node2D) -> void:
	if body is player:
		_player_body_in = false
