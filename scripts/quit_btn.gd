extends TextureButton

func _on_pressed() -> void :
	SoundManager.play()
	get_tree().quit()
