extends CharacterBody2D

# Movement variables
@export var speed := 220.0
@export var rotate_sprite := true


var health_component: HealthComponent

func _ready():

	health_component = $HealthComponent
	if health_component:
		health_component.health_depleted.connect(on_health_depleted)

func on_health_depleted():

	print("Character died!")


func _physics_process(_delta):
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = input_dir * speed
	move_and_slide()
	if rotate_sprite and velocity.length() > 0 and has_node("Sprite2D"):
		$Sprite2D.rotation = velocity.angle()

func take_damage(amount: int):
	if health_component:
		health_component.subtract_health(amount)

func heal(amount: int):
	if health_component:
		health_component.add_health(amount)
