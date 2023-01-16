extends TouchScreenButton


func _ready():
	self.visible = OS.has_feature("mobile")
