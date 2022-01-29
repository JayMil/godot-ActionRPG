extends Node

export(int) var start_health = 1 setget set_start_health


var max_health = start_health setget set_max_health
var health = max_health setget set_health
var killedBats = 0 setget set_killed_bats

signal death
signal health_changed(value)
signal max_health_changed(value)
signal killed_bats_changed(value)

func set_start_health(value):
	start_health = max(value, 1)

func set_max_health(value):
	max_health = max(value, 1)
	self.health = min(health, max_health)
	emit_signal("max_health_changed", max_health)
	

func set_health(value):
	health = value
	emit_signal("health_changed", health)
	if health <= 0:
		emit_signal("death")
		
func set_killed_bats(value):
	killedBats = value
	emit_signal("killed_bats_changed", killedBats)
	
func reset():
	self.max_health = start_health
	self.health = max_health
	self.killedBats = 0

func _ready():
	reset()
