
extends "entity.gd"

var spell_wait = 0
var spell_cd = 3

func _init().(10):
	pass

func _ready():
	set_fixed_process(true)
	
func _fixed_process(delta):
	var rel = get_translation() - Global_vars.player.get_translation()
	if rel.length() > 15:
		move_towards(-rel.normalized())
	elif rel.length() <= 10 and moving:
		stop_move()
		
	if spell_wait > 0:
		spell_wait -= delta
	else:
		rel.y = 0
		primary_spell_cast(-rel)
		spell_wait = spell_cd