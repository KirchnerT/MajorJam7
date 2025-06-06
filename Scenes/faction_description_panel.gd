extends Panel

####################################################################
## This class will be used for setting the faction description
## text and textures
####################################################################

@onready var tutorial: Label = $Tutorial
@onready var texture_rect: TextureRect = $TextureRect
@onready var rich_text_label: RichTextLabel = $RichTextLabel
@onready var faction_name: Label = $FactionName


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


func update_information() -> void:
	pass
