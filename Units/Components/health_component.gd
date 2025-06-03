extends Node2D
class_name HealthComponent

signal unit_has_died

@onready var crow_dot_timer: Timer = $CrowDotTimer

#Global Variables
@export var unit_health: float
var crow_particle_scene: PackedScene = preload("res://Units/Witch/Crow_Caller/crow_particle.tscn")

var is_crowed: bool = false
var crow_particle: GPUParticles2D

func _ready() -> void:
	var _particle = crow_particle_scene.instantiate()
	_particle.position = position
	_particle.rotation = rotation
	_particle.emitting = false
	self.add_child(_particle)
	crow_particle = _particle

# function that changes the health components health value
func take_damage(damage_taken: float) -> void:
	unit_health = unit_health - damage_taken
	if unit_health <= 0:
		unit_has_died.emit()


func change_crow_dot(_is_crowed: bool) -> void:
	print("Crow Changed to " + str(_is_crowed))
	if is_crowed == _is_crowed:
		return
	
	is_crowed = _is_crowed
	
	if is_crowed:
		crow_particle.emitting = true
		crow_dot_timer.start()
	else:
		crow_particle.emitting = false
		crow_dot_timer.stop()


func _on_crow_dot_timer_timeout() -> void:
	print("CROW DAMAGE")
	take_damage(StatusEffectInfo.crow_damage)
