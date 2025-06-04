extends UnitBase
class_name CrowCaller

@export var effect_range: float = 100.0
@export var max_affected_enemies_count: int = 1
@export var effect_duration: float = 2.0

func _on_ability_component_use_ability() -> void:
	var enemies_in_range
	var all_enemies = get_tree().get_nodes_in_group(movement_component.get_string_of_unit_group(movement_component.unit_target_faction))
	var enemies_to_give_effects_to = enemies_to_give_status_effects(all_enemies, Enums.StatusEffects.CROW, max_affected_enemies_count, effect_range)
	
	for i in enemies_to_give_effects_to.size():
		if i < enemies_to_give_effects_to.size():
			var enemy = enemies_to_give_effects_to[i] as UnitBase
			if enemy != null:
				enemy.add_status_effect(Enums.StatusEffects.CROW, self, effect_duration)
