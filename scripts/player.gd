
extends "entity.gd"

export var start_dir = Vector3(0, 0, -1)

const RIGHT = Vector3(1, 0, 0)
const UP = Vector3(0, 0, -1)

var spawn_point = Vector3(0, 0, 0)
var death_cd = 0

var should_teleport = false
var tele_location = Vector3(0, 0, 0)

func _init().(10, 100):
	connect("spawn", self, "_on_spawn")
	connect("death", self, "_on_death")

func _ready():
	set_fixed_process(true)
	set_process(true)
	
	var cam = get_node("/root/Node/Camera")
	cam.connect("primary_spell_cast", self, "_primary_spell_cast")
	
	spawn_point = get_translation()
	
func _process(delta):
	if is_dead():
		if death_cd <= 0:
			anim_player.play_backwards("die")
			should_teleport = true
			tele_location = spawn_point
			spawn()
		else:
			death_cd -= delta
	
func _fixed_process(delta):
	if should_teleport:
		should_teleport = false
		move_to(tele_location)
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
		
	move_towards(motion)
	
func _primary_spell_cast(pos):
	var rel = pos - get_translation()
	rel.y = 0
	primary_spell_cast(rel)

func _on_death():
	death_cd = 5
	Global_vars.player = null
	
func _on_spawn():
	Global_vars.player = self