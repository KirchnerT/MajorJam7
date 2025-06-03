extends Node2D
class_name UnitBase

@onready var attack_component: AttackComponent = $AttackComponent
@onready var movement_component: MovementComponent = $MovementComponent
@onready var health_component: HealthComponent = $HealthComponent
@onready var status_effects_component: StatusEffectsComponent = $StatusEffectsComponent
@onready var ability_component: AbilityComponent = $AbilityComponent
@onready var sprite_component: SpriteComponent = $SpriteComponent

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	movement_component.attack_range = attack_component.attack_range
	
	# connect signals
	movement_component.new_target_found.connect(_on_movement_component_new_target_found)
	
	attack_component.is_within_attack_range_changed.connect(_on_attack_component_is_within_attack_range_changed)
	attack_component.attack_target_unit.connect(_on_attack_component_attack_target_unit)
	
	health_component.unit_has_died.connect(_on_health_component_unit_has_died)
	
	# Taunt
	status_effects_component.taunt_ended.connect(_on_status_effects_component_taunt_ended)
	status_effects_component.taunt_started.connect(_on_status_effects_component_taunt_started)
	# Crow
	status_effects_component.crow_ended.connect(_on_status_effects_component_crow_ended)
	status_effects_component.crow_started.connect(_on_status_effects_component_crow_started)
	if ability_component != null:
		ability_component.use_ability.connect(_on_ability_component_use_ability)
	
	sprite_component.stop_walk_animation()
	deactivate()


func deactivate() -> void:
	movement_component.set_process(false)
	attack_component.set_process(false)
	health_component.set_process(false)
	status_effects_component.set_process(false)
	if ability_component != null:
		ability_component.stop_ability_timer()
		ability_component.set_process(false)


func activate() -> void:
	movement_component.set_process(true)
	attack_component.set_process(true)
	health_component.set_process(true)
	status_effects_component.set_process(true)
	
	if ability_component != null:
		ability_component.activate_ability_timer()
		ability_component.set_process(true)
	
	sprite_component.play_walk_animation()


func take_damage(damage: float) -> void:
	sprite_component.stop_walk_animation()
	sprite_component.play_flash_animation()
	health_component.take_damage(damage)


func _on_movement_component_new_target_found(new_target: Node2D) -> void:
	attack_component.target_unit = new_target


func _on_attack_component_is_within_attack_range_changed(is_within_attack_range: bool) -> void:
	if is_within_attack_range:
		sprite_component.play_walk_animation()
	else:
		sprite_component.stop_walk_animation()
	movement_component.can_move = !is_within_attack_range


func _on_health_component_unit_has_died() -> void:
	queue_free()
	return


func _on_attack_component_attack_target_unit(unit_to_attack: Node2D, attack_damage: float) -> void:
	sprite_component.play_attack_animation()
	unit_to_attack.take_damage(attack_damage)


func _on_ability_component_use_ability() -> void:
	printerr("Unimplented Ability Signal Error")


func _on_status_effects_component_taunt_ended() -> void:
	movement_component.taunt_effect(false)


func _on_status_effects_component_taunt_started(taunt_source: Node2D) -> void:
	movement_component.taunt_effect(true, taunt_source)


func _on_status_effects_component_crow_ended() -> void:
	health_component.change_crow_dot(false)


func _on_status_effects_component_crow_started(taunt_source: Node2D) -> void:
	health_component.change_crow_dot(true)


func add_status_effect(effect: Enums.StatusEffects, source: Node2D, duration: float) -> void:
	status_effects_component.give_status_effect(effect, source, duration)


func enemies_to_give_status_effects(all_enemies: Array[Node], status_effect: Enums.StatusEffects, number_of_enemies_to_effect: int) -> Array[UnitBase]:
	var enemies_to_give_effects: Array[UnitBase] = []
	
	if all_enemies.size() < number_of_enemies_to_effect:
		for enemy in all_enemies:
			enemies_to_give_effects.append(enemy as UnitBase)

	# filter out enemies without that status effect
	var enemies_without_status = all_enemies.filter(func(enemy): return !enemy.status_effects_component.current_status_effects.has(Enums.StatusEffects.CROW))
	
	if enemies_without_status.size() == number_of_enemies_to_effect:
		for i in number_of_enemies_to_effect:
			enemies_to_give_effects.append(enemies_without_status[i] as UnitBase)
	elif enemies_without_status.size() > number_of_enemies_to_effect:
		for i in number_of_enemies_to_effect:
			enemies_to_give_effects.append(enemies_without_status[i] as UnitBase)
	else:
		enemies_to_give_effects.append(enemies_without_status as Array[UnitBase])
	
	return enemies_to_give_effects
