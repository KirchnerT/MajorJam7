extends UnitBase
class_name SoulLeech

@export_range (0, 1) var lifesteal_percent: float

func _on_attack_component_attack_target_unit(unit_to_attack: Node2D, attack_damage: float) -> void:
	super(unit_to_attack, attack_damage)
	
	var hp_to_gain: float = attack_damage * lifesteal_percent * -1
	print("Lifesteal: " + str(hp_to_gain))
	take_damage(hp_to_gain, self)
