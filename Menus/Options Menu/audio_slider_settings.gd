extends Control

@onready var audio_name_label: Label = $"HBoxContainer/Audio Name Label" as Label
@onready var h_slider: HSlider = $HBoxContainer/HSlider as HSlider


@export_enum("Master", "Music", "SFX") var bus_name : string

var bus_index: int = 0
