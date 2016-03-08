
var name = ""
var weight = 0

func _init(name, weight=1):
	self.name = name
	self.weight = weight
	
func duplicate():
	return get_script().new(name, weight)