extends Node2D


@export var devil_shop_quips: Array[String]
@export var witch_shop_quips: Array[String]
@export var lich_shop_quips: Array[String]
@export var imp_shop_quips: Array[String]

@export var devil_battle_quips: Array[String]
@export var witch_battle_quips: Array[String]
@export var lich_battle_quips: Array[String]
@export var imp_battle_quips: Array[String]


func get_random_shop_quip(faction: AllyArmy.FACTIONS) -> String:
	return "Quip"


func get_random_battle_quip(faction: AllyArmy.FACTIONS) -> String:
	return "Quip"
