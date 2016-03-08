
extends RigidBody

const MODE_NORMAL = 0
const MODE_BOUNCING = 1

var p_mode = MODE_NORMAL

var direction = Vector3(0, 0, 0)
var speed = 0

var activated = false

signal collision(body)

func _ready():
	set_fixed_process(true)
	
	set_contact_monitor(true)
	set_max_contacts_reported(1)
	set_use_continuous_collision_detection(true)
		
func _fixed_process(delta):
	if not activated:
		return
	var colls = get_colliding_bodies()
	if colls.size() > 0:
		emit_signal("collision", colls[0])
		
func _integrate_forces(state):
	if p_mode == MODE_NORMAL:
		state.set_linear_velocity(direction * speed)
	
func set_direction(new_dir):
	direction = new_dir.normalized()
	
func set_speed(new_speed):
	speed = new_speed
	
func activate():
	activated = true
	if p_mode == MODE_BOUNCING:
		apply_impulse(Vector3(0, 0, 0), direction * speed)
	
func set_projectile_mode(new):
	p_mode = new
	if p_mode == MODE_NORMAL:
		set_use_custom_integrator(true)
	if p_mode == MODE_BOUNCING:
		set_bounce(0.8)

