extends Node2D
class_name TempArcher

@onready var attack_component: AttackComponent = $AttackComponent
@onready var movement_component: MovementComponent = $MovementComponent
@onready var health_component: HealthComponent = $HealthComponent

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	deactivate()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func deactivate() -> void:
	movement_component.set_process(false)
	attack_component.set_process(false)
	health_component.set_process(false)


func activate() -> void:
	movement_component.set_process(true)
	attack_component.set_process(true)
	health_component.set_process(true)


func _on_movement_component_new_target_found(new_target: Node2D) -> void:
	attack_component.target_unit = new_target


func _on_attack_component_is_within_attack_range_changed(is_within_attack_range: bool) -> void:
	movement_component.can_move = !is_within_attack_range


func _on_health_component_unit_has_died() -> void:
	queue_free()
	return
