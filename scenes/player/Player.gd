extends CharacterBody2D
class_name player

# Movement variables
@export var speed := 120.0
@export var rotate_sprite := false

@onready var animation_tree: AnimationTree = $AnimationTree

const IG_HEALTHDOWN_SFX = preload("res://assets/SFX/IG_death_sfx.wav")

var health_component: HealthComponent
var can_move : bool = true

func _enter_tree() -> void:
	NavigationManager.on_triger_player_spawn.connect(spawnPlayer)

func _ready():
	health_component = $HealthComponent
	if health_component:
		health_component.health_depleted.connect(on_health_depleted)

func on_health_depleted():
	SignalBus.on_player_died.emit()

func _process(delta: float) -> void:
	if velocity == Vector2.ZERO or !can_move:
		animation_tree.get("parameters/playback").travel("idle")
	else:
		animation_tree.get("parameters/playback").travel("walk")
		animation_tree.set("parameters/idle/blend_position", velocity.normalized())
		animation_tree.set("parameters/walk/blend_position", velocity.normalized())

func _physics_process(_delta):
	if !can_move:
		animation_tree.get("parameters/playback").travel("idle")
		return
	var input_dir := Input.get_vector("Left", "Right", "Up", "Down")
	velocity = input_dir * speed
	move_and_slide()
	if rotate_sprite and velocity.length() > 0 and has_node("PlayerSprite"):
		$PlayerSprite.rotation = velocity.angle()

func test():
	print("test")

func take_damage(amount: int):
	if health_component:
		AudioManager.play_sfx(IG_HEALTHDOWN_SFX, -8)
		health_component.subtract_health(amount)

func heal(amount: int):
	if health_component:
		health_component.add_health(amount)

func spawnPlayer(pos: Vector2, dir: String) -> void:
	global_position = pos
	match dir:
		"up":
			animation_tree.set("parameters/idle/blend_position", Vector2(0, -1))
		"down":
			animation_tree.set("parameters/idle/blend_position", Vector2(0, 1))
		"left":
			animation_tree.set("parameters/idle/blend_position", Vector2(-1, 0))
		"right":
			animation_tree.set("parameters/idle/blend_position", Vector2(1, 0))
