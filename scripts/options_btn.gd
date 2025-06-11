extends TextureButton


func _on_pressed() -> void :
	SoundManager.play()
	var option_menu = preload("res://scenes/options_menu.tscn").instantiate()
	get_parent().add_child(option_menu)


func _on_v_box_container_draw() -> void:
	pass # Replace with function body.
