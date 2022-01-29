extends Control


var hearts = 4 setget set_hearts
var max_hearts = 4 setget set_max_hearts

var stats = PlayerStats

onready var heartUIFull = $HeartUIFull
onready var heartUIEmpty = $HeartUIEmpty



func set_hearts(value):
	hearts = clamp(value, 0, max_hearts)
	if heartUIFull != null:
		heartUIFull.rect_size.x = hearts * 15

	
func set_max_hearts(value):
	max_hearts = value
	if heartUIEmpty != null:
		heartUIEmpty.rect_size.x = max_hearts * 15
	
func _ready():
	self.max_hearts = stats.max_health
	self.hearts = stats.health
# warning-ignore:return_value_discarded
	stats.connect("health_changed", self, "set_hearts")
# warning-ignore:return_value_discarded
	stats.connect("max_health_changed", self, "set_max_hearts")
