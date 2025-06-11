@tool
extends Control

# --- EXPORT VARIABLES ---
# These will show up in the Inspector, letting you customize this
# control for different purposes without changing the code.

# The input actions to trigger (e.g., "move_left", "move_right")
@export var left_action: StringName
@export var right_action: StringName

# The textures for each state
@export var neutral_texture: Texture2D
@export var left_texture: Texture2D
@export var right_texture: Texture2D


# --- "PRIVATE" VARIABLES (using GDScript convention) ---
@onready var control_texture = self

# An enum to represent the possible states of our control
enum State { NEUTRAL, LEFT, RIGHT }
var _current_state = State.NEUTRAL

# This stores the ID of the finger currently pressing this control.
# -1 means no finger is pressing it.
var _touch_index = -1


# This function runs once when the scene is ready.
func _ready():
	# Set the initial texture when the game starts.
	control_texture.texture = neutral_texture


# This is the core function that processes all input events.
func _input(event):
	# If the game isn't running, don't process player input in the editor.
	if Engine.is_editor_hint():
		return
		
	# Case 1: A finger touches down on the screen
	if event is InputEventScreenTouch and event.pressed:
		# Check if the touch is inside our control's area AND if no other finger is already controlling us.
		if get_rect().has_point(event.position) and _touch_index == -1:
			# Capture this finger's ID.
			_touch_index = event.index
			# Immediately check the finger's position and update the state.
			update_state_from_position(event.position)

	# Case 2: A finger is lifted from the screen
	elif event is InputEventScreenTouch and not event.pressed:
		# Check if this is the finger we are tracking.
		if event.index == _touch_index:
			# Release control, reset to neutral.
			_touch_index = -1
			set_state(State.NEUTRAL)

	# Case 3: A finger is dragged across the screen
	elif event is InputEventScreenDrag:
		# Check if this is the finger we are tracking.
		if event.index == _touch_index:
			# Update the state based on the new finger position.
			update_state_from_position(event.position)


# Determines the state based on finger position.
func update_state_from_position(finger_position: Vector2):
	# Calculate the finger's horizontal position relative to the center of our control.
	var local_x = finger_position.x - get_global_rect().position.x - (size.x / 2)
	
	# A "deadzone" in the middle so the control doesn't flicker.
	# We'll use 15% of the control's width as the deadzone.
	var deadzone_width = size.x * 0.15

	if local_x < -deadzone_width:
		set_state(State.LEFT)
	elif local_x > deadzone_width:
		set_state(State.RIGHT)
	else:
		set_state(State.NEUTRAL)


# This function handles all the logic for changing state.
func set_state(new_state: State):
	# If the state hasn't changed, do nothing.
	if new_state == _current_state:
		return

	_current_state = new_state

	# Change the texture and fire the correct input actions.
	match _current_state:
		State.NEUTRAL:
			control_texture.texture = neutral_texture
			# Release both actions to stop movement.
			if not Engine.is_editor_hint():
				Input.action_release(left_action)
				Input.action_release(right_action)
		
		State.LEFT:
			control_texture.texture = left_texture
			# Press the left action and make sure the right action is released.
			if not Engine.is_editor_hint():
				Input.action_press(left_action)
				Input.action_release(right_action)
			
		State.RIGHT:
			control_texture.texture = right_texture
			# Press the right action and make sure the left action is released.
			if not Engine.is_editor_hint():
				Input.action_press(right_action)
				Input.action_release(left_action)
