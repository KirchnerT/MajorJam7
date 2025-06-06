extends Panel
class_name FactionShopsPanel

signal pressed(faction: int)

var devil_is_hovered: bool = false
var imp_is_hovered: bool = false
var lich_is_hovered: bool = false
var witch_is_hovered: bool = false

@onready var devil_highlight: TextureRect = $DevilHighlight
@onready var imp_highlight: TextureRect = $ImpHighlight
@onready var witch_highlight: TextureRect = $WitchHighlight
@onready var lich_highlight: TextureRect = $LichHighlight

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
	imp_is_hovered = false
	lich_is_hovered = false
	witch_is_hovered = false
	
	devil_highlight.visible = true
	imp_highlight.visible = false
	lich_highlight.visible = false
	witch_highlight.visible = false
	
func _on_devil_area_mouse_exited() -> void:
	devil_is_hovered = false
	devil_highlight.visible = false


func _on_imp_mouse_entered() -> void:
	devil_is_hovered = false
	imp_is_hovered = true
	lich_is_hovered = false
	witch_is_hovered = false
	
	devil_highlight.visible = false
	imp_highlight.visible = true
	lich_highlight.visible = false
	witch_highlight.visible = false

func _on_imp_mouse_exited() -> void:
	imp_is_hovered = false
	imp_highlight.visible = false

func _on_witch_area_mouse_entered() -> void:
	devil_is_hovered = false
	imp_is_hovered = false
	lich_is_hovered = false
	witch_is_hovered = true
	
	devil_highlight.visible = false
	imp_highlight.visible = false
	lich_highlight.visible = false
	witch_highlight.visible = true

func _on_witch_area_mouse_exited() -> void:
	witch_is_hovered = false
	witch_highlight.visible = false

func _on_lich_area_mouse_entered() -> void:
	devil_is_hovered = false
	imp_is_hovered = false
	lich_is_hovered = true
	witch_is_hovered = false
	
	devil_highlight.visible = false
	imp_highlight.visible = false
	lich_highlight.visible = true
	witch_highlight.visible = false

func _on_lich_area_mouse_exited() -> void:
	lich_is_hovered = false
	lich_highlight.visible = false
