extends UnitBase
class_name Scamperling

@export var taunt_range: float = 100.0
@export var tauntable_enemies_count: int = 5
@export var taunt_duration: float = 2.0
@export var dodge_chance: float = 25.0


func _on_ability_component_use_ability() -> void:
	var enemies_in_range: Array[Node2D]
	var all_enemies = get_tree().get_nodes_in_group(movement_component.get_string_of_unit_group(movement_component.unit_target_faction))
	var enemies_to_give_effects_to = enemies_to_give_status_effects(all_enemies, Enums.StatusEffects.TAUNT, tauntable_enemies_count)
	
	for i in tauntable_enemies_count:
		if i < enemies_to_give_effects_to.size():
			var enemy: UnitBase = enemies_to_give_effects_to[i]
			if enemy != null:
				enemy.add_status_effect(Enums.StatusEffects.TAUNT, self, taunt_duration)

func take_damage(damage: float) -> void:
	var has_dodged_attack: bool = randi_range(0, 100) <= dodge_chance
	
	if !has_dodged_attack:
		super(damage)
