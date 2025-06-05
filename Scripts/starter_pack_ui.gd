extends TextureRect
class_name StarterPackUi

signal starter_pack_chosen(starter_pack)

@export var starter_pack: CardPack
@export var label_name: String

@onready var name_label: Label = $Label


func _ready() -> void:
	name_label.text = label_name.to_upper()

func _on_button_pressed() -> void:
	starter_pack_chosen.emit(starter_pack)
