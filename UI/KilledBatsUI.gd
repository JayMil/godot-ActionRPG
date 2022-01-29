extends Control

var playerStats = PlayerStats

onready var killedBatsLabel = $HBoxContainer/KilledBatsLabel


func set_killed_bats(value):
	killedBatsLabel.text = str(value)

	
func _ready():
	set_killed_bats(0)
# warning-ignore:return_value_discarded
	playerStats.connect("killed_bats_changed", self, "set_killed_bats")
