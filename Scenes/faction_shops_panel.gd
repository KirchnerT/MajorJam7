extends Panel
class_name FactionShopsPanel

signal pressed(faction: int)

var devil_is_hovered: bool = false
var imp_is_hovered: bool = false
var lich_is_hovered: bool = false
var witch_is_hovered: bool = false

@onready var devil_highlight: TextureRect = $DevilHighlight

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if devil_is_hovered:
				pressed.emit(AllyArmy.FACTIONS.DEVILS)
			elif imp_is_hovered:
				pressed.emit(AllyArmy.FACTIONS.IMPS)
			elif lich_is_hovered:
				pressed.emit(AllyArmy.FACTIONS.LICHES)
			elif witch_is_hovered:
				pressed.emit(AllyArmy.FACTIONS.WITCHES)


func _on_devil_area_mouse_entered() -> void:
	devil_is_hovered = true
	devil_highlight.visible = true


func _on_devil_area_mouse_exited() -> void:
	devil_is_hovered = false
	devil_highlight.visible = false
