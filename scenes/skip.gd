extends TouchScreenButton


func _ready():
	self.visible = OS.has_feature("mobile") ||JavaScript.eval("(('ontouchstart' in window) || (navigator.maxTouchPoints > 0) || (navigator.msMaxTouchPoints > 0))", true)
