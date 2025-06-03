extends UnitBase
class_name FlameAdjudicator

@export_range (0, 1) var damage_increase_percentage: float

var damage_increase: float

func _ready() -> void:
	damage_increase = attack_component.attack_damage * damage_increase_percentage
	super()

func _on_ability_component_use_ability() -> void:
	attack_component.attack_damage += damage_increase
