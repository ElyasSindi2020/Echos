extends Panel

@onready var heart: Sprite2D = $heart


func _ready() -> void :
	pass



func _process(_delta: float) -> void :
	pass

func update(whole: bool):
	if whole:
		heart.visible = true
	else:
		heart.visible = false
