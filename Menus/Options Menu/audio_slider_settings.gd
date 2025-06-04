extends Control

@onready var audio_name_label: Label = $"HBoxContainer/Audio Name Label" as Label
@onready var h_slider: HSlider = $HBoxContainer/HSlider as HSlider


@export_enum("Master", "MUSIC", "SFX") var bus_name : String

var bus_index: int = 0

func _ready():
	h_slider.value_changed.connect(on_value_changed)
	get_bus_name_by_index()
	set_name_label_text()
	set_slider_value()

# Sets the name of the label depending on the bus	
func set_name_label_text() -> void:
	audio_name_label.text = str(bus_name).to_upper() + " VOLUME"
	
# Grabs the bus name from the Audio Server
func get_bus_name_by_index() -> void:
	bus_index = AudioServer.get_bus_index(bus_name)

# Sets the initial slider value 
func set_slider_value() -> void:
	h_slider.value = db_to_linear(AudioServer.get_bus_volume_db(bus_index))

# Updates the bus volume based on what bus is being adjusted
func on_value_changed(value: float):
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))
	
