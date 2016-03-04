
extends Spatial

export var start_dir = Vector3(0, 0, -1)

const RIGHT = Vector3(1, 0, 0)
const UP = Vector3(0, 0, -1)
const RUN_SPEED = 10

# animation variables

var moving = false
var prev_dir = Vector3(0, 0, 0)

var target_rot = 0

var angle = 0

var target_dir = Vector3(0, 0, 0)
var dir = Vector3(0, 0, 0)


# nodes

onready var anim_player = get_node("AnimationPlayer")
onready var mesh = get_node("Armature/Skeleton/Player")

func _ready():
	set_look_at(start_dir)
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
	set_look_at(dir.linear_interpolate(target_dir, 20 * delta))
	
# Animation callbacks
func _moving_changed():
	if moving:
		anim_player.play("run")
	else:
		anim_player.play("idle")

func _dir_changed(new_dir):
	target_dir = new_dir
	
func set_look_at(new_dir):
	dir = new_dir
	var pos = mesh.get_global_transform().origin
	mesh.look_at(pos - new_dir, Vector3(0, 1, 0))