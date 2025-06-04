extends Node2D
class_name EventManager

signal event_ended()
signal start_event(event_data: EventDisplayData)

@export_range (0,1) var event_chance: float
@export var events: Array[EventResource]

var cur_event: EventResource

func attempt_event_start() -> void:
	if randi_range(0, 1) > event_chance:
		event_ended.emit()
		return
	
	# Pick a random event
	cur_event = events[randi_range(0, events.size() - 1)]
	
	# Setup event
	var new_display_data: EventDisplayData = EventDisplayData.new(cur_event.name, 
											 cur_event.description[0], "", "", "")
	# display event
	start_event.emit(new_display_data)


class EventDisplayData:
	var title: String
	var type: String
	var description: String
	var choice_1_text: String
	var choice_2_text: String
	var choice_3_text: String
	var leave_text: String = "Leave"
	
	func _init(_title: String, _description: String, _choice_1_text: String, 
			   _choice_2_text: String, _choice_3_text: String, _leave_text: String = "Leave") -> void:
		title = _title
		description = _description
		choice_1_text = _choice_1_text
		choice_2_text = _choice_2_text
		choice_3_text = _choice_3_text
		leave_text = _leave_text
