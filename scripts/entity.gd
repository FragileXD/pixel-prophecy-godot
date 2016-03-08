
extends KinematicBody

signal spawn
signal death
signal death_end
signal damage(amount)

# Body variables
var run_speed = 1

var dir = Vector3(0, 0, 0)
var prev_dir = Vector3(0, 0, 0)
var target_dir = Vector3(0, 0, 0)

var target_move_dir = Vector3(0, 0, 0)

var moving = false

onready var mesh = get_node("Player-Model/Armature/Skeleton/Mesh")
onready var anim_player = get_node("Player-Model/AnimationPlayer")

# Entity variables
var health = 0
var max_health = 0
var takes_damage = true

var spawn_shapes = []
var spawn_transforms = []

func _init(runspeed, hp):
	run_speed = runspeed
	health = hp
	max_health = hp

func _ready():
	set_fixed_process(true)
	for i in range(get_shape_count()):
		spawn_transforms.append(get_shape_transform(i))
		spawn_shapes.append(get_shape(i).duplicate(true))
		
	set_look_at(Vector3(1, 0, 0))
	target_dir = Vector3(1, 0, 0)
	
	anim_player.connect("finished", self, "_anim_finished")
	
func _enter_tree():
	spawn()
	
func _fixed_process(delta):
	if is_dead():
		return
		
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
	if is_dead():
		return
		
	dir = dir.normalized()
	var fireball = preload("res://scenes/objects/fireball.tscn").instance()
	fireball.set_direction(dir)
	fireball.set_damage(50)
	fireball.set_translation(get_translation() + Vector3(0, 2, 0) + dir * 2)
	get_node("/root/Node").add_child(fireball)
	fireball.activate()
	
# Damage D:
	
func attempt_damage(amount):
	if takes_damage:
		receive_damage(damage_applied(amount))
	emit_signal("damage", amount)
	
# Method to be overriden if not taking full damage etc
func damage_applied(amount):
	return amount
	
func receive_damage(amount):
	health -= amount
	if is_dead():
		emit_signal("death")
		anim_player.play("die")
		clear_shapes()

func is_dead():
	return health <= 0
	
func _anim_finished():
	if anim_player.get_current_animation() == "die":
		emit_signal("death_end")
		
func spawn():
	var i = 0
	for shape in spawn_shapes:
		add_shape(shape)
		set_shape_transform(i, spawn_transforms[i])
		i += 1
	if anim_player != null:
		anim_player.play_backwards("die")
	health = max_health
	emit_signal("spawn")
	