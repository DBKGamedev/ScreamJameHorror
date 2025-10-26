extends CharacterBody2D

var speed : float = 50.0
@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D

var _player : player
var player_in : bool

func _ready() -> void:
	for i in get_tree().get_nodes_in_group("Player"):
		_player = i

func _physics_process(delta: float) -> void:
	var dir = to_local(nav_agent.get_next_path_position()).normalized()
	velocity = dir * speed
	move_and_slide()



func _on_nav_timer_timeout() -> void:
	nav_agent.target_position = _player.global_position


func _on_speed_timer_timeout() -> void:
	speed = 500


func _on_hurt_area_body_entered(body: Node2D) -> void:
	if body is player:
		player_in = true
		

func _on_hurt_area_body_exited(body: Node2D) -> void:
	if body is player:
		player_in = false


func _on_attack_timer_timeout() -> void:
	if player_in:
		print("hurt")
		_player.take_damage(5)
