
extends "projectile_rigid.gd"

var damage = 0

func _ready():
	set_mode(MODE_NORMAL)
	connect("collision", self, "_collision")
	
func _collision(body):
	speed = 0
	var explosion = preload("res://scenes/objects/expolsion.tscn").instance()
	explosion.set_transform(get_transform())
	get_parent().add_child(explosion)
	explosion.connect("exit_tree", self, "_explosion_effect_leave")
	clear_shapes()
	get_node("Fire").set_emitting(false)
	remove_child(get_node("Light"))
	
	if (body extends preload("entity.gd")):
		body.attempt_damage(damage)
	
func _explosion_effect_leave():
	queue_free()
	
func set_damage(new_damage):
	damage = new_damage

