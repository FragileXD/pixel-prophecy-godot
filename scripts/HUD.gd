
extends Control

var inventory

func _ready():
	inventory = get_node("inventory")
	set_process_input(true)
	
func _input(event):
	if event.is_action_released("inventory_toggle"):
		if inventory.is_visible():
			inventory.hide()
		else:
			update_inventory()
			inventory.popup()
			
func update_inventory():
	
	var box = inventory.get_node("items/scroll/items-box")
	for node in box.get_children():
		box.remove_child(node)
	var button = Button.new()
	button.set_v_size_flags(SIZE_EXPAND_FILL)
	button.set_custom_minimum_size(Vector2(0, 100))
	button.set_text("Hello!!")
	box.add_child(button)
