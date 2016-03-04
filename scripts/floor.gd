
extends KinematicBody

signal spell_cast(pos)

func _input_event(camera, event, click_pos, click_normal, shape_idx):
	if (event.type==InputEvent.MOUSE_BUTTON and event.pressed):
		emit_signal("spell_cast", click_pos)
