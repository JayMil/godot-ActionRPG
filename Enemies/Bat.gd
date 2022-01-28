extends KinematicBody2D

const EnemyDeathEffect = preload("res://Effects/EnemyDeathEffect.tscn")

export var ACCELERATION = 4
export var MAX_SPEED = 100
export var FRICTION = 5
export var KNOCKBACK = 200
export var WANDER_TARGET_RANGE = 4

onready var stats = $Stats
onready var playerDetectionZone = $PlayerDetectionZone
onready var sprite = $AnimatedBatSprite
onready var hurtbox = $Hurtbox
onready var softCollision = $SoftCollision
onready var wanderController = $WanderController
onready var animationPlayer = $BlinkAnimationPlayer

enum {
	IDLE,
	WANDER,
	CHASE
}

var velocity = Vector2.ZERO
var knockback = Vector2.ZERO

var state = IDLE

func _ready():
	choose_state()


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


func idle_state(_delta):
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION)
	
	seek_player()
	if wanderController.get_time_left() == 0:
		choose_state()

func wander_state():
	
	seek_player()
	if wanderController.get_time_left() == 0:
		choose_state()
	
	accelerate_towards_point(wanderController.target_position)
	
	if global_position.distance_to(wanderController.target_position) <= WANDER_TARGET_RANGE:
		choose_state()
	
func chase_state(_delta):
	var player = playerDetectionZone.player
	if player != null:
		accelerate_towards_point(player.global_position)
	else:
		state = IDLE
	
func choose_state():
	state = pick_random_state([IDLE, WANDER])
	wanderController.start_wander_timer(rand_range(1, 3))
		
func seek_player():
	if playerDetectionZone.can_see_player():
		state = CHASE
		
func accelerate_towards_point(position):
	var direction = global_position.direction_to(position)
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION)
	sprite.flip_h = velocity.x < 0
		
func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()
	
	
func _on_Hurtbox_area_entered(hitbox):
	stats.health -= hitbox.damage
	knockback = hitbox.knockback_vector * KNOCKBACK
	hurtbox.create_hit_effect()
	hurtbox.start_invincibility(0.4)


func _on_Stats_death():
	queue_free()
	create_enemy_death_effect()
	
func create_enemy_death_effect():
	var enemyDeathEffect = EnemyDeathEffect.instance()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = global_position


func _on_Hurtbox_invincibility_started():
	animationPlayer.play("Start")


func _on_Hurtbox_invincibility_ended():
	animationPlayer.play("Stop")
