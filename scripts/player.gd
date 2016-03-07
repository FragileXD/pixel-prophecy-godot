
extends "entity.gd"

export var start_dir = Vector3(0, 0, -1)

const RIGHT = Vector3(1, 0, 0)
const UP = Vector3(0, 0, -1)

func _init().(10):
	pass

func _ready():
	set_fixed_process(true)
	
	var cam = get_node("/root/Node/Camera")
	cam.connect("primary_spell_cast", self, "_primary_spell_cast")
	
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
		
	move_towards(motion)

func _enter_tree():
	Global_vars.player = self
	
func _primary_spell_cast(pos):
	var rel = pos - get_translation()
	rel.y = 0
	primary_spell_cast(rel)