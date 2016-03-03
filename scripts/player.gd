
extends Spatial

const RIGHT = Vector3(1, 0, 0)
const UP = Vector3(0, 0, -1)
const RUN_SPEED = 10

# animation variables

var moving = false
var prev_dir = Vector3(0, 0, 0)

var target_rot = 0

var angle = 0


# nodes

onready var anim_player = get_node("AnimationPlayer")
onready var mesh = get_node("Armature/Skeleton/Player")

func _ready():
	set_fixed_process(true)
	
func _fixed_process(delta):
	var left = Input.is_action_pressed("move_left")
	var right = Input.is_action_pressed("move_right")
	var up = Input.is_action_pressed("move_up")
	var down = Input.is_action_pressed("move_down")
	
	var motion = Vector3(0, 0, 0)
	if right:
		motion += RIGHT
	if left:
		motion -= RIGHT
	if up:
		motion += UP
	if down:
		motion -= UP
	
	if motion.length() > 0 and not moving:
		moving = true
		_moving_changed()
	elif motion.length() == 0 and moving:
		moving = false
		_moving_changed()
		
	if moving and prev_dir != motion:
		prev_dir = motion
		_dir_changed(motion)
	
	translate(motion.normalized() * RUN_SPEED * delta)
	
# Animation callbacks
func _moving_changed():
	if moving:
		anim_player.play("run")
	else:
		anim_player.play("idle")

func _dir_changed(new_dir):
	var nd2 = Vector2(new_dir.x, new_dir.z)
	mesh.set_rotation(Vector3(0, nd2.angle(), 0))