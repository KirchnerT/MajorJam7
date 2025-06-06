extends Node2D
class_name EventManager

signal event_ended
signal start_event(event_data: EventDisplayData)
signal proceed_event(event_data: EventDisplayData)
signal ally_army_was_shuffled
signal game_over

@export_range (0,1) var event_chance: float
@export var events: Array[EventResource]

var start_event_chance: float
var event_stage: int = 0
var cur_event: EventResource


func _ready() -> void:
	start_event_chance = event_chance

func attempt_event_start() -> void:
	var random_number: int = randi_range(1, 100)
	if random_number as float / 100 > event_chance:
		event_ended.emit()
		event_chance += 0.05 # increase odds of event on next day by 5%
		return
	
	event_chance = start_event_chance # reset event chance if an event happens
	
	# Pick a random event
	cur_event = events[randi_range(0, events.size() - 1)]
	
	# Setup event
	var new_display_data: EventDisplayData = EventDisplayData.new(cur_event.name, 
													cur_event.description[0], "NEXT", "")
	# display event
	event_stage = 1
	start_event.emit(new_display_data)


func proceed(pressed_leave: bool = false) -> void:
	if pressed_leave:
		end_event()
	match cur_event.type:
		"Rule Modifier":
			proceed_rule_modifier_event()
		"Roulette":
			proceed_roulette_event()
		_:
			printerr("Unimplemented Event Type")


func proceed_rule_modifier_event() -> void:
	if event_stage == 1:
		var effect_keys: Array = cur_event.effects.keys()
		
		var choosen_effect_key: String = effect_keys[randi_range(0, effect_keys.size() - 1)]
		var choosen_effect_desc: String = cur_event.effects[choosen_effect_key]
		var event_description = cur_event.description[0] + choosen_effect_desc
		var new_display_data: EventDisplayData = EventDisplayData.new(cur_event.name, 
																event_description, "", "LEAVE")
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

func proceed_roulette_event() -> void:
	if event_stage == 0:
		var event_description = cur_event.description[0]
		var new_display_data: EventDisplayData = EventDisplayData.new(cur_event.name, 
													event_description, "SPIN", "")
		
		event_stage = 1
		proceed_event.emit(new_display_data)
	elif event_stage == 1:
		var event_description = cur_event.description[0] + "\n\n" + cur_event.description[1]
		var new_display_data: EventDisplayData = EventDisplayData.new(cur_event.name, 
													event_description, "CONTINUE", "")
		
		event_stage = 2
		proceed_event.emit(new_display_data)
	elif event_stage == 2:
		var effect_keys: Array = cur_event.effects.keys()
		
		var random_roulette_key: int = effect_keys[randi_range(0, effect_keys.size() - 1)]
		var choosen_effect_desc: String = cur_event.effects[random_roulette_key]
		var event_description = cur_event.description[0] + "\n\n" + cur_event.description[1] + "\n\n\n" + choosen_effect_desc
		var new_display_data: EventDisplayData = EventDisplayData.new(cur_event.name, 
																event_description, "", "LEAVE")
		match random_roulette_key:
			1:
				var filled_containers: Array[int]
				
				for i in AllyArmy.unit_containers.size():
					if AllyArmy.unit_containers[i] != null:
						filled_containers.append(i)
				
				if filled_containers.size() == 1:
					new_display_data.description += "\nYOU ONLY HAVE ONE UNIT\nLUCKY DUCKY"
				else:
					filled_containers.shuffle()
					
					AllyArmy.unit_containers[filled_containers[0]] = null
					ally_army_was_shuffled.emit()
			2:
				AllyArmy.phylux = AllyArmy.phylux / 2
			3:
				var random_unit_container: UnitContainerInfo
				var random_index: int
				
				while random_unit_container == null:
					random_index = randi_range(0, AllyArmy.unit_containers.size() - 1)
					random_unit_container = AllyArmy.unit_containers[random_index]
				
				var index_to_copy_to: int = random_index
				
				while index_to_copy_to == random_index:
					index_to_copy_to = randi_range(0, AllyArmy.unit_containers.size() - 1)
				
				AllyArmy.unit_containers[index_to_copy_to] = random_unit_container
				ally_army_was_shuffled.emit()
			4:
				AllyArmy.unit_containers.shuffle()
				ally_army_was_shuffled.emit()
			_:
				printerr("Effect Not Valid")
		
		event_stage = 3
		proceed_event.emit(new_display_data)
	elif event_stage == 3:
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
		description = "\n" + _description
		next_text = _next_text
		leave_text = _leave_text
