extends UnitBase
class_name Brewmistress

@export var splash_range: float = 30.0
@export var effect_damage: float = 4.0
@export var throw_distance: float = 75.0

@export var potion_splash_particle: PackedScene


func _on_ability_component_use_ability() -> void:
	var units_in_range: Array[Node]
	var all_units: Array[Node]
	var is_healing: bool = randi_range(0,100) > 50
	var potion_damage: float = effect_damage
	
	if is_healing:
		potion_damage *= -1
		var all_allies = get_tree().get_nodes_in_group(movement_component.get_string_of_unit_group(movement_component.unit_allegience))
		all_units = all_allies
	else:
		var all_enemies = get_tree().get_nodes_in_group(movement_component.get_string_of_unit_group(movement_component.unit_target_faction))
		all_units = all_enemies
	
	for unit in all_units as Array[UnitBase]:
		if global_position.distance_to(unit.global_position) < throw_distance:
			units_in_range.append(unit)
	
	if units_in_range.size() == 0:
		return
	
	# pick a random unit in range to chuck the potion at
	var unit_position_to_throw_at: Vector2 = units_in_range[randi_range(0, units_in_range.size() - 1)].global_position
	
	for unit in all_units as Array[UnitBase]:
		if global_position.distance_to(unit_position_to_throw_at) > splash_range:
			unit.take_damage(potion_damage)
	
	#spawn particle on position
	var _particle = potion_splash_particle.instantiate()
	_particle.position = unit_position_to_throw_at
	_particle.rotation = global_rotation
	_particle.emitting = true
	get_tree().current_scene.add_child(_particle)
	
## Radius of the circle
#var circle_radius = 75.0
## Color of the circle
#var circle_color = Color(1, 0, 0) # Red
#
#func _draw():
	## Draw the circle at the node's position.
	#draw_circle(Vector2(0, 0), circle_radius, circle_color)
