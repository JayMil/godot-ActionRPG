extends Area2D

const HitEffect = preload("res://Effects/HitEffect.tscn")

onready var timer = $Timer
onready var collisionShape = $CollisionShape2D

var invincible = false setget set_invincible

var wasHit = false

signal invincibility_started
signal invincibility_ended
signal hit_started
signal hit_ended

func hit(invincibility_timeout):
	if timer.get_time_left() == 0:
		wasHit = true
		start_invincibility(invincibility_timeout)
		_create_hit_effect()

func set_invincible(value):
	invincible = value
	if invincible:
		if wasHit:
			emit_signal("hit_started")
		emit_signal("invincibility_started")
	else:
		emit_signal("invincibility_ended")
		if wasHit:
			wasHit = false
			emit_signal("hit_ended")
		
func start_invincibility(duration):
	self.invincible = true
	timer.start(duration)

func _create_hit_effect():
	var effect = HitEffect.instance()
	var main = get_tree().current_scene
	main.add_child(effect)
	effect.global_position = global_position
	

func _on_Timer_timeout():
	self.invincible = false


func _on_Hurtbox_invincibility_started():
	collisionShape.set_deferred("disabled", true)

func _on_Hurtbox_invincibility_ended():
	collisionShape.disabled = false
