extends CharacterBody2D

@export var speed := 200.0
@export var acceleration := 10000.0
@export var friction := 10000.0
@export var rotate_sprite := true

func _physics_process(delta):
	var input_dir := Input.get_vector("Left", "Right", "Up", "Down")
	
	if input_dir != Vector2.ZERO:
		velocity = velocity.move_toward(input_dir * speed, acceleration * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	
	move_and_slide()
	
	if rotate_sprite and velocity.length() > 0 and has_node("Sprite2D"):
		$Sprite2D.rotation = velocity.angle()
