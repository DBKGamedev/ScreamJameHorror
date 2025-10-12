class_name HealthComponent
extends Node

@export var max_health := 100
var current_health: int

signal health_changed(new_health)
signal health_depleted()

func _ready():
	current_health = max_health
	health_changed.emit(current_health)

# Health management functions
func add_health(amount: int) -> void:
	current_health += amount
	if current_health > max_health:
		current_health = max_health
	health_changed.emit(current_health)

func subtract_health(amount: int) -> void:
	current_health -= amount
	health_changed.emit(current_health)
	
	if current_health <= 0:
		current_health = 0
		health_depleted.emit()

func on_health_zero() -> void:

	print("Health reached zero! Character should die now.")
