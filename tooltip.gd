extends Control
class_name Tooltip

@onready var rich_text_label: RichTextLabel = $Panel/MarginContainer/RichTextLabel
@onready var hover_delay: Timer = $HoverDelay

var is_activating: bool = false

func _ready() -> void:
	hover_delay.timeout.connect(show_tooltip)

func Config(for_text: String) -> void:
	if not rich_text_label:
		await self.ready
		
	rich_text_label.text = "\n" + for_text


func activate_tooltip() -> void:
	if hover_delay.is_stopped() && !is_activating:
		is_activating = true
		hover_delay.start()


func deactivate_tooltip() -> void:
	hover_delay.stop()
	is_activating = false
	visible = false


func show_tooltip() -> void:
	is_activating = false
	visible = true
