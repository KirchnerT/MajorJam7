class_name UnitContainerInfo

######################################################
## General class to hold specific unit based information
######################################################

var unit_resource: UnitResource
var unit_count: int
var unit_group: String

func _init(_unit_resource: UnitResource, _unit_count: int, _unit_group: String):
	unit_resource = _unit_resource
	unit_count = _unit_count
	unit_group = _unit_group
