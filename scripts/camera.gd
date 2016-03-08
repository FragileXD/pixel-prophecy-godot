
extends InterpolatedCamera

const RAY_LEN = 1000

var should_ray = false
var from = Vector3(0, 0, 0)
var to = Vector3(0, 0, 0)

signal primary_spell_cast

func _ready():
	set_fixed_process(true)
	get_node("HUD").connect("input_event", self, "_input")
	
func _fixed_process(delta):
	if should_ray:
		should_ray = false
		var state = get_world().get_direct_space_state()
		var result = state.intersect_ray(from, to)
		if not result.empty():
			emit_signal("primary_spell_cast", result.position)

func _input(ev):
	if ev.is_action_pressed("primary_spell"):
		from = project_ray_origin(ev.pos)
		to = from + project_ray_normal(ev.pos) * RAY_LEN
		should_ray = true