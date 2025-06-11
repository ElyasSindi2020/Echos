# This script goes on the CanvasLayer that is a CHILD of the player node.
extends CanvasLayer

# We don't need an @export variable because the player is always our direct parent.
var _player: CharacterBody2D


# The _ready() function runs once, when this UI element enters the game.
func _ready():
	# Check if the game is running on the Android platform using the lowercase feature tag.
	if OS.has_feature("android"):
		# If we ARE on Android, then set up the controls normally.
		_player = get_parent()

		# Connect to the player's built-in "visibility_changed" signal.
		_player.visibility_changed.connect(_on_player_visibility_changed)

		# Set the initial visibility of the controls to match the player's.
		self.visible = _player.visible
	else:
		# If we are NOT on Android (e.g., Windows, Linux, Mac), just hide this entire UI layer.
		self.hide()


# This function runs automatically when the signal is fired (only on Android).
func _on_player_visibility_changed():
	# Match our visibility to the player's new visibility.
	self.visible = _player.visible
