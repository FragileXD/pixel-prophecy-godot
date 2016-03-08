
extends RigidBody

var direction = Vector3(0, 0, 0)
var speed = 25

var exploded = false
var explosion_left = 0
var explosion_time = 1

onready var fire_particles = get_node("Fire")

var damage = 0

func _ready():
	set_fixed_process(true)
	
func _fixed_process(delta):
	
	if is_colliding() > 0 and not exploded:
		exploded = true
		if get_collider() extends preload("entity.gd"):
			get_collider().receive_damage(damage)
		explosion_left = explosion_time
		var explosion = preload("res://scenes/objects/expolsion.tscn").instance()
		explosion.set_translation(get_translation())
		get_parent().add_child(explosion)
		fire_particles.set_emitting(false)
		remove_child(get_node("Light"))
		set_collide_with_character_bodies(false)
		set_collide_with_kinematic_bodies(false)
		set_collide_with_rigid_bodies(false)
		set_collide_with_static_bodies(false)
	
	move(direction * delta * speed)
	
	if exploded and explosion_left > 0:
		explosion_left -= delta
	if exploded and explosion_left <= 0:
		free()
	
func set_direction(dir):
	direction = dir
	
func set_damage(amount):
	damage = amount
