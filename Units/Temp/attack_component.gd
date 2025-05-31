extends Node2D
class_name AttackComponent

signal is_within_attack_range_changed(is_within_attack_range: bool)

@export var attack_damage: float
@export var attack_range: float
@export var attack_speed: float
@export var attack_speed_timer: Timer

var can_attack: bool = true

var target_unit: Node2D

var is_within_attack_range: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Start timer and add its signal to this script to do attack rate
	 # Replace with function body.
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if target_unit == null:
		return
	
	var distance_to_target = get_parent().global_position.distance_to(target_unit.global_position)

	if distance_to_target <= attack_range && is_within_attack_range == false:
		is_within_attack_range = true
		is_within_attack_range_changed.emit(true)
	elif distance_to_target > attack_range && is_within_attack_range == true:
		is_within_attack_range = false
		is_within_attack_range_changed.emit(false)

	if can_attack == true && is_within_attack_range == true:
		attack_target()
		
func attack_target() -> void:
	# Check if target is able to be damaged (ie: has health component, or you can assume they do since they are targetable)
	#	call the targets damage function
	can_attack = false
	target_unit.health_component.take_damage(attack_damage) #testing
	attack_speed_timer.start()
		# gets the take damage function from the health_component script to deal damage to the unit
		
		
	pass

func _on_attack_speed_timer_timeout() -> void:
	can_attack = true # Replace with function body.
