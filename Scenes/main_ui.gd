extends Control
class_name MainUi

signal starter_pack_selected(starter_pack: CardPack)

@export var starter_packs: Array[StarterPackUi]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for starter_pack in starter_packs:
		starter_pack.starter_pack_chosen.connect(starter_pack_chosen)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func starter_pack_chosen(starter_pack: CardPack) -> void:
	starter_pack_selected.emit(starter_pack)
	visible = false
