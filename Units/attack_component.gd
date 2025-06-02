extends Node2D
class_name AttackComponent

signal is_within_attack_range_changed(is_within_attack_range: bool)

@export var attack_damage: float
@export var attack_range: float
@export var attack_speed: float
@export var attack_speed_timer: Timer

var can_attack: bool = true

var target_unit: Node2D

var is_within_attack_range: bool = false:
	get:
		return is_within_attack_range
	set(value):
		is_within_attack_range_changed.emit(value)
		is_within_attack_range = value


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	attack_speed_timer.wait_time = attack_speed
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if target_unit == null:
		return
	
	var distance_to_target = get_parent().global_position.distance_to(target_unit.global_position)

	if distance_to_target <= attack_range && is_within_attack_range == false:
		is_within_attack_range = true
	elif distance_to_target > attack_range && is_within_attack_range == true:
		is_within_attack_range = false
	
	# MUST check both values as true as these are our conditions to "Attack"
	if can_attack == true && is_within_attack_range == true:
		attack_target()



func attack_target() -> void:
	if target_unit == null:
		return
	
	can_attack = false
	target_unit.health_component.take_damage(attack_damage)
	attack_speed_timer.start()


func _on_attack_speed_timer_timeout() -> void:
	can_attack = true # Replace with function body.
