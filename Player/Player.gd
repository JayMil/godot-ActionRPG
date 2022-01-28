extends KinematicBody2D

const PlayerHurtSound = preload("res://Player/PlayerHurtSound.tscn")

const ACCELERATION = 25
const MAX_SPEED = 100
const ROLL_SPEED = 120
const FRICTION = 15

enum {
	MOVE,
	ROLL,
	ATTACK
}

var state = MOVE
var velocity = Vector2.ZERO
var roll_vector = Vector2.DOWN

# global autoload PlayerStats
var stats = PlayerStats

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var swordHitbox = $HitboxPivot/SwordHitbox
onready var hurtbox = $Hurtbox
onready var blinkAnimationPlayer = $BlinkAnimationPlayer
onready var rollTimer = $Timers/RollTimer

func _ready():
	randomize()
	stats.connect("death", self, "queue_free")
	animationTree.active = true
	swordHitbox.knockback_vector = roll_vector
		
func _physics_process(_delta):
	match state:
		MOVE:   move_state()
		ROLL:   roll_state()
		ATTACK: attack_state()
			
	
func roll_state():
	velocity = roll_vector * ROLL_SPEED
	hurtbox.start_invincibility(0.4)
	animationState.travel("Roll")
	move()
	
func attack_state():
	velocity = Vector2.ZERO
	animationState.travel("Attack")
	
func move():
	velocity = move_and_slide(velocity)
	
func attack_animation_finished():
	state = MOVE
	
func roll_animation_finished():
	velocity = Vector2.ZERO
	state = MOVE
	rollTimer.start(.5)
	
func move_state():
	
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		roll_vector = input_vector
		swordHitbox.knockback_vector = input_vector
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationTree.set("parameters/Attack/blend_position", input_vector)
		animationTree.set("parameters/Roll/blend_position", input_vector)
		animationState.travel("Run")
			
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION)
		
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION)
		
	move()
	
	if Input.is_action_just_pressed("attack"):
		state = ATTACK
		
	if Input.is_action_just_pressed("roll"):
		if rollTimer.get_time_left() == 0:
			state = ROLL


func _on_Hurtbox_area_entered(area):
	stats.health -= area.damage
	hurtbox.hit(0.6)
	var playerHurtSound = PlayerHurtSound.instance()
	get_tree().current_scene.add_child(playerHurtSound)



func _on_Hurtbox_hit_started():
	blinkAnimationPlayer.play("Start")


func _on_Hurtbox_hit_ended():
	blinkAnimationPlayer.play("Stop")
