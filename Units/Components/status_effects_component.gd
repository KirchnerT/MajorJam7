extends Node2D
class_name StatusEffectsComponent

signal taunt_ended()
signal taunt_started(taunt_source: Node2D)

signal crow_ended()
signal crow_started(effect_source: UnitBase)

var current_status_effects: Array[Enums.StatusEffects]

@onready var taunt_timer: Timer = $TauntTimer
@onready var crow_timer: Timer = $CrowTimer


func give_status_effect(effect: Enums.StatusEffects, source: Node2D, duration: float) -> void:
	match effect:
		Enums.StatusEffects.TAUNT:
			current_status_effects.append(Enums.StatusEffects.TAUNT)
			set_taunt_timer(source, duration)
		Enums.StatusEffects.CROW:
			current_status_effects.append(Enums.StatusEffects.CROW)
			set_crow_timer(source, duration)
		_:
			printerr(str(effect) + " is invalid")


func set_taunt_timer(taunt_source: Node2D, wait_time: float) -> void:
	taunt_timer.stop()
	taunt_timer.wait_time = wait_time
	taunt_started.emit(taunt_source)
	taunt_timer.start()


func _on_taunt_timer_timeout() -> void:
	taunt_ended.emit()


func set_crow_timer(effect_source: Node2D, wait_time: float) -> void:
	crow_timer.stop()
	crow_timer.wait_time = wait_time
	crow_started.emit(effect_source)
	crow_timer.start()


func _on_crow_timer_timeout() -> void:
	crow_ended.emit()
