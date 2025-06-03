extends Node2D
class_name AbilityComponent

signal use_ability()

@onready var ability_timer: Timer = $AbilityTimer

@export var ability_energy_cost: float
@export var ability_recharge_rate: float = 10.0 # 10 energy/second
@export var is_single_use: float = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var ability_timer_wait: float = ability_energy_cost / ability_recharge_rate
	ability_timer.wait_time = ability_timer_wait


func activate_ability_timer() -> void:
	ability_timer.start()


func stop_ability_timer() -> void:
	ability_timer.stop()


func _on_ability_timer_timeout() -> void:
	use_ability.emit()
	
	if !is_single_use:
		ability_timer.start()
