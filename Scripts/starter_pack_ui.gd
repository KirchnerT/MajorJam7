extends TextureRect
class_name StarterPackUi

signal starter_pack_chosen(starter_pack)

@export var starter_pack: CardPack

func _on_button_pressed() -> void:
	starter_pack_chosen.emit(starter_pack)
