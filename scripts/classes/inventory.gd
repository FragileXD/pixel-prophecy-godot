
# classes
var item_class = preload("item.gd")

var items = []
var weight_capacity = 0

const SUCCESS = 0
const TOO_HEAVY = 1
const NOT_ITEM = 2

func _init(weight_capacity=10):
	self.weight_capacity = weight_capacity
	
func add_item(item):
	if item extends item_class:
		if get_weight() + item.weight > weight_capacity:
			return TOO_HEAVY
		items.append(item)
		return SUCCESS
	else:
		return NOT_ITEM
		
	
func get_weight():
	var w = 0
	for item in items:
		w += item.weight
	return w