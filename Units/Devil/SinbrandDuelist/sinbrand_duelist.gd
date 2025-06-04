extends UnitBase
class_name SinbrandDuelist

@export var damage_mult_on_low_unit: float

func _on_attack_component_attack_target_unit(unit_to_attack: Node2D, attack_damage: float) -> void:
	sprite_component.play_attack_animation()
	unit_to_attack.take_damage(attack_damage, self, damage_mult_on_low_unit)
