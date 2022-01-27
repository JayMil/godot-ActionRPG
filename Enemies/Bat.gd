extends KinematicBody2D

const EnemyDeathEffect = preload("res://Effects/EnemyDeathEffect.tscn")

export var ACCELERATION = 4
export var MAX_SPEED = 100
export var FRICTION = 5
export var KNOCKBACK = 200

onready var stats = $Stats
onready var playerDetectionZone = $PlayerDetectionZone
onready var sprite = $AnimatedBatSprite
onready var hurtbox = $Hurtbox
onready var softCollision = $SoftCollision

enum {
	IDLE,
	WANDER,
	CHASE
}

var velocity = Vector2.ZERO
var knockback = Vector2.ZERO

var state = IDLE


func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION)
	knockback = move_and_slide(knockback)
	
	match state:
		IDLE:   idle_state(delta)
		WANDER: wander_state()
		CHASE:  chase_state(delta)
	
	if softCollision.is_colliding():
		velocity += softCollision.get_push_vector() * 20
	velocity = move_and_slide(velocity)


func idle_state(delta):
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION)
	seek_player()

func wander_state():
	pass
	
func chase_state(delta):
	var player = playerDetectionZone.player
	if player != null:
		var direction = (player.global_position - global_position).normalized()
		velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION)
	else:
		state = IDLE
	sprite.flip_h = velocity.x < 0
	
func seek_player():
	if playerDetectionZone.can_see_player():
		state = CHASE
	
func _on_Hurtbox_area_entered(hitbox):
	stats.health -= hitbox.damage
	knockback = hitbox.knockback_vector * KNOCKBACK
	hurtbox.create_hit_effect()


func _on_Stats_death():
	queue_free()
	create_enemy_death_effect()
	
func create_enemy_death_effect():
	var enemyDeathEffect = EnemyDeathEffect.instance()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = global_position
