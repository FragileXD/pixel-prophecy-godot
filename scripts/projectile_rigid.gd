
extends RigidBody

const MODE_NORMAL = 0
const MODE_BOUNCING = 1

var mode = MODE_NORMAL

var direction = Vector3(0, 0, 0)
var speed = 0

signal collision(body)

func _ready():
	set_fixed_process(true)
	
	set_contact_monitor(true)
	set_max_contacts_reported(1)
	set_use_continuous_collision_detection(true)
	
	if mode == MODE_NORMAL:
		set_use_custom_integrator(true)
		
func _fixed_process(delta):
	var colls = get_colliding_bodies()
	if colls.size() > 0:
		emit_signal("collision", colls[0])
		
func _integrate_forces(state):
	if mode != MODE_NORMAL:
		return
		
	state.set_linear_velocity(direction * speed)
	
func set_direction(new_dir, new_speed):
	direction = new_dir.normalized()
	speed = new_speed


