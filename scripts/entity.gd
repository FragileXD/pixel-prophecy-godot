
extends KinematicBody

var run_speed = 1

var dir = Vector3(0, 0, 0)
var prev_dir = Vector3(0, 0, 0)
var target_dir = Vector3(0, 0, 0)

var target_move_dir = Vector3(0, 0, 0)

var moving = false

onready var mesh = get_node("Player-Model/Armature/Skeleton/Mesh")
onready var anim_player = get_node("Player-Model/AnimationPlayer")

func _init(runspeed):
	run_speed = runspeed

func _ready():
	set_fixed_process(true)
	set_collide_with_kinematic_bodies(false)
	
	set_look_at(Vector3(1, 0, 0))
	target_dir = Vector3(1, 0, 0)
	
func _fixed_process(delta):
	var motion = target_move_dir
	
	if motion.length() > 0 and not moving:
		moving = true
		_moving_changed()
	elif motion.length() == 0 and moving:
		moving = false
		_moving_changed()
		
	if moving and prev_dir != motion:
		prev_dir = motion
		_dir_changed(motion)
		
	motion = motion.normalized() * run_speed * delta
	
	if is_colliding():
		var n = get_collision_normal()
		motion = n.slide(motion)
	
	move(motion)
	set_look_at(dir.linear_interpolate(target_dir, 20 * delta))
	
	
func move_towards(move_dir):
	target_move_dir = move_dir.normalized()
	
func stop_move():
	target_move_dir = Vector3(0, 0, 0)
	
func set_look_at(new_dir):
	dir = new_dir
	var pos = mesh.get_global_transform().origin
	mesh.look_at(pos - new_dir, Vector3(0, 1, 0))

# Animation callbacks
func _moving_changed():
	if moving:
		anim_player.play("run")
	else:
		anim_player.play("idle")

func _dir_changed(new_dir):
	target_dir = new_dir
	
## Spells!

func primary_spell_cast(dir):
	dir = dir.normalized()
	var fireball = preload("res://scenes/objects/fireball.tscn").instance()
	fireball.set_direction(dir)
	fireball.set_translation(get_translation() + Vector3(0, 2, 0) + dir * 2)
	get_node("/root/Node").add_child(fireball)
