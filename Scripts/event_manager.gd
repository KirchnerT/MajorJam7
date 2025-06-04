extends Node2D
class_name EventManager

signal event_ended()
signal start_event(event_data: EventDisplayData)
signal proceed_event(event_data: EventDisplayData)

@export_range (0,1) var event_chance: float
@export var events: Array[EventResource]

var event_stage: int = 0
var cur_event: EventResource

func attempt_event_start() -> void:
	if randi_range(0, 1) > event_chance:
		event_ended.emit()
		return
	
	# Pick a random event
	cur_event = events[randi_range(0, events.size() - 1)]
	
	# Setup event
	var new_display_data: EventDisplayData = EventDisplayData.new(cur_event.name, 
													cur_event.description[0], "Next", "")
	# display event
	event_stage = 1
	start_event.emit(new_display_data)


func proceed(pressed_leave: bool = false) -> void:
	if pressed_leave:
		end_event()
	match cur_event.type:
		"Rule Modifier":
			proceed_rule_modifier_event()
		_:
			printerr("Unimplemented Event Type")


func proceed_rule_modifier_event() -> void:
	if event_stage == 1:
		var effect_keys: Array = cur_event.effects.keys()
		var choosen_effect_key: String = effect_keys[randi_range(0, effect_keys.size() - 1)]
		var choosen_effect_desc: String = cur_event.effects[choosen_effect_key]
		var event_description = cur_event.description[0] + choosen_effect_desc
		var new_display_data: EventDisplayData = EventDisplayData.new(cur_event.name, 
																event_description, "", "Leave")
		match choosen_effect_key:
			"ReverseHeal":
				AllyArmy.current_law = Enums.LawEffects.REVERSEHEAL
			"AllyAttack":
				AllyArmy.current_law = Enums.LawEffects.ALLYATTACK
			"DoubleAbilities":
				AllyArmy.current_law = Enums.LawEffects.DOUBLEABILITY
			_:
				printerr("Effect Not Valid")
		
		event_stage = 2
		proceed_event.emit(new_display_data)
	elif event_stage == 2:
		end_event()
	else:
		printerr("Event Stage Invalid")


func end_event() -> void:
	event_stage = 0
	cur_event = null
	event_ended.emit()

class EventDisplayData:
	var title: String
	var type: String
	var description: String
	var next_text: String
	var leave_text: String
	
	func _init(_title: String, _description: String, _next_text: String, _leave_text: String) -> void:
		title = _title
		description = _description
		next_text = _next_text
		leave_text = _leave_text
