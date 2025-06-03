extends UnitBase
class_name BombImp

@export var explosion_radius: float = 20.0
@export var explosion_particle: PackedScene


func _on_health_component_unit_has_died() -> void:
	var _particle = explosion_particle.instantiate()
	_particle.position = global_position
	_particle.rotation = global_rotation
	_particle.emitting = true
	get_tree().current_scene.add_child(_particle)
	
	super()


func _on_attack_component_attack_target_unit(unit_to_attack: Node2D, attack_damage: float) -> void:
	var enemies_in_range: Array[Node2D]
	var all_enemies = get_tree().get_nodes_in_group(movement_component.get_string_of_unit_group(movement_component.unit_target_faction))
	
	for enemy in all_enemies:
		if global_position.distance_to(enemy.global_position) <= explosion_radius:
			enemy.take_damage(attack_damage)
	
	take_damage(9999999)
