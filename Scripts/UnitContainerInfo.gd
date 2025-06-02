class_name UnitContainerInfo

######################################################
## General class to hold specific unit based information
######################################################

var unit_resource: UnitResource
var unit_count: int
var unit_group: String

func _init(unit_resource: UnitResource, unit_count: int, unit_group: String):
	self.unit_resource = unit_resource
	self.unit_count = unit_count
	self.unit_group = unit_group
