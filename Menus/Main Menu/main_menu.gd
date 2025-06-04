extends Control




func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/battle_map.tscn") # Replace with function body.


func _on_decks_pressed() -> void:
	get_tree().change_scene_to_file("res://Menus/Factions Menu/decks_menu.tscn") # Replace with function body.


func _on_options_pressed() -> void:
	get_tree().change_scene_to_file("res://Menus/Options Menu/options_menu.tscn") # Replace with function body.


func _on_quit_pressed() -> void:
	get_tree().quit() # Replace with function body.


func _on_credits_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Menus/Credits Menu/credits_menu.tscn") # Replace with function body.
