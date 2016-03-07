
extends Particles

var particle_lifetime = 0.025
var lifetime = 0.8

func _ready():
	set_process(true)
	
func _process(delta):
	if particle_lifetime > 0:
		particle_lifetime -= delta
	else:
		set_emitting(false)
		
	if lifetime > 0:
		lifetime -= delta
	else:
		queue_free()