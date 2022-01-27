extends Node


export var max_health = 1

# set health on ready so that enherited usage updates apply
onready var health = max_health

signal death


func damage(damage_amount):
	health -= damage_amount
	if health <= 0:
		emit_signal("death")
	

