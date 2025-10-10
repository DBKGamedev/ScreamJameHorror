extends CharacterBody2D

@export var speed := 220.0
@export var acceleration := 1200.0
@export var friction := 1000.0
@export var rotate_sprite := true

func _physics_process(delta):
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	if input_dir != Vector2.ZERO:
		velocity = velocity.move_toward(input_dir * speed, acceleration * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	
	move_and_slide()
	
	if rotate_sprite and velocity.length() > 0 and has_node("Sprite2D"):
		$Sprite2D.rotation = velocity.angle()
