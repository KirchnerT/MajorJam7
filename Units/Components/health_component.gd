extends Node2D
class_name HealthComponent

signal unit_has_died

@onready var crow_dot_timer: Timer = $CrowDotTimer

#Global Variables
var unit_health: float
@export var max_health: float = 10
var crow_particle_scene: PackedScene = preload("res://Units/Witch/Crow_Caller/crow_particle.tscn")

var is_crowed: bool = false
var crow_source: UnitBase
var crow_particle: GPUParticles2D

func _ready() -> void:
	unit_health = max_health
	var _particle = crow_particle_scene.instantiate()
	_particle.position = position
	_particle.rotation = rotation
	_particle.emitting = false
	self.add_child(_particle)
	crow_particle = _particle


# function that changes the health components health value
func take_damage(damage_taken: float, source: UnitBase, damage_mult_low_health: float = 1) -> void:
	if unit_health / max_health < 0.4:
		damage_taken *= damage_mult_low_health
	
	unit_health = unit_health - damage_taken
	if unit_health <= 0:
		unit_has_died.emit()
	elif unit_health > max_health:
		unit_health = max_health


func change_crow_dot(_is_crowed: bool, source: UnitBase) -> void:
	print("Crow Changed to " + str(_is_crowed))
	if is_crowed == _is_crowed:
		return
	
	is_crowed = _is_crowed
	crow_source = source

	if is_crowed:
		crow_particle.emitting = true
		crow_dot_timer.start()
	else:
		crow_particle.emitting = false
		crow_dot_timer.stop()


func _on_crow_dot_timer_timeout() -> void:
	print("CROW DAMAGE")
	take_damage(StatusEffectInfo.crow_damage, crow_source)
