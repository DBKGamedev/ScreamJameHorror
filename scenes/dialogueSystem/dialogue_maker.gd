extends Node2D
class_name DialogueMaker

const DIALOGUE_SYSTEM = preload("res://scenes/dialogueSystem/dialogue_system.tscn")

@export var activate_instant: bool
@export var only_activate_once: bool
@export var free_maker_after_finished: bool = false
@export var override_dialogue_position: bool
@export var override_position: Vector2
@export var dialouge: Array[DE]

@onready var interactable: Area2D = $interactable

var _player_body_in: bool = false
var _has_activated: bool = false
var _disired_dialogue_pos : Vector2

var _player: player

signal dialouge_finished_maker

func _ready() -> void:
	for i in get_tree().get_nodes_in_group("Player"):
		_player = i

func _process(delta: float) -> void:
	if !_player:
		for i in get_tree().get_nodes_in_group("Player"):
			_player = i
		return

func _activate_dialoge() -> void:
	_player.can_move = false
	var Dialogue = DIALOGUE_SYSTEM.instantiate()
	get_parent().add_child(Dialogue)
	Dialogue.dialouge_finished.connect(dialouge_finished)
	if override_dialogue_position:
		_disired_dialogue_pos = override_position
	else:
		var dialouge_pos_marker = _player.find_child("DialoguePos")
		_disired_dialogue_pos = dialouge_pos_marker.global_position
	
	Dialogue.global_position = _disired_dialogue_pos
	Dialogue._dilogue = dialouge
	_has_activated = true

func dialouge_finished() -> void:
	if free_maker_after_finished:
		dialouge_finished_maker.emit()
		queue_free()

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
