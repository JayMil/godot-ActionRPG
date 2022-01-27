extends Node


export(int) var max_health = 1 setget set_max_health

# set health on ready so that enherited usage updates apply
var health = max_health setget set_health

signal death
signal health_changed(value)
signal max_health_changed(value)

func set_max_health(value):
	max_health = max(value, 1)
	self.health = min(health, max_health)
	emit_signal("max_health_changed", max_health)
	

func set_health(value):
	health = value
	emit_signal("health_changed", health)
	if health <= 0:
		emit_signal("death")
	

func _ready():
	self.health = max_health
