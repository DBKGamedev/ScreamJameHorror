extends CharacterBody2D

# Movement variables
@export var speed := 220.0
@export var rotate_sprite := false

@onready var animation_tree: AnimationTree = $AnimationTree

var health_component: HealthComponent

func _ready():

	health_component = $HealthComponent
	if health_component:
		health_component.health_depleted.connect(on_health_depleted)

func on_health_depleted():
	SignalBus.on_player_died.emit()

func _process(delta: float) -> void:
	if velocity == Vector2.ZERO:
		pass
	else:
		animation_tree.set("parameters/idle/blend_position", velocity.normalized())

func _physics_process(_delta):
	var input_dir := Input.get_vector("Left", "Right", "Up", "Down")
	velocity = input_dir * speed
	move_and_slide()
	if rotate_sprite and velocity.length() > 0 and has_node("PlayerSprite"):
		$PlayerSprite.rotation = velocity.angle()

func take_damage(amount: int):
	if health_component:
		health_component.subtract_health(amount)

func heal(amount: int):
	if health_component:
		health_component.add_health(amount)
