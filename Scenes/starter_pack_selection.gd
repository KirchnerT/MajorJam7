extends Panel
class_name StarterPackSelection

@export var witch_starter_info: StartPackInfoResource
@export var imp_starter_info: StartPackInfoResource
@export var devil_starter_info: StartPackInfoResource
@export var lich_starter_info: StartPackInfoResource

@onready var texture_rect: TextureRect = $FactionDescriptionPanel/TextureRect
@onready var rich_text_label: RichTextLabel = $FactionDescriptionPanel/RichTextLabel
@onready var faction_name: Label = $FactionDescriptionPanel/FactionName

func _ready() -> void:
	hide_data()


func set_data(info: StartPackInfoResource):
	texture_rect.texture = info.faction_portrait
	rich_text_label.text = "\n" + info.faction_description.to_upper()
	faction_name.text = info.faction_name.to_upper()
	
	texture_rect.visible = true
	rich_text_label.visible = true
	faction_name.visible = true


func hide_data() -> void:
	texture_rect.visible = false
	rich_text_label.visible = false
	faction_name.visible = false


func _on_witch_mouse_has_entered() -> void:
	set_data(witch_starter_info)


func _on_witch_mouse_has_exited() -> void:
	hide_data()


func _on_lich_mouse_has_entered() -> void:
	set_data(lich_starter_info)


func _on_lich_mouse_has_exited() -> void:
	hide_data()


func _on_devil_mouse_has_entered() -> void:
	set_data(devil_starter_info)


func _on_devil_mouse_has_exited() -> void:
	hide_data()


func _on_imp_mouse_has_entered() -> void:
	set_data(imp_starter_info)


func _on_imp_mouse_has_exited() -> void:
	hide_data()
