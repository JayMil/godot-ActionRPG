extends Area2D

const HitEffect = preload("res://Effects/HitEffect.tscn")

onready var timer = $Timer

var invincible = false setget set_invincible

signal invincibility_started
signal invincibility_ended


func set_invincible(value):
	invincible = value
	if invincible:
		emit_signal("invincibility_started")
	else:
		emit_signal("invincibility_ended")
		
func start_invincibility(duration):
	self.invincible = true
	timer.start(duration)

func create_hit_effect():
	var effect = HitEffect.instance()
	var main = get_tree().current_scene
	main.add_child(effect)
	effect.global_position = global_position
	

func _on_Timer_timeout():
	self.invincible = false


func _on_Hurtbox_invincibility_started():
	# set monitorable with deferred so that it doesn't mess with physics calculations
	set_deferred("monitorable", false)

func _on_Hurtbox_invincibility_ended():
	monitorable = true