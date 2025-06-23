extends CursorState
class_name CursorStateDefault


func on_state_entered() -> void:
	# Called when the default state is entered
	print("Default cursor state entered")
	# Optionally set the cursor sprite or other properties here

func on_input(event: InputEvent) -> void:
	# Handle input events specific to the default cursor state
	if event is InputEventMouseButton:
		if event.is_pressed():
			print("Mouse button pressed in default state")
		else:
			print("Mouse button released in default state")
	elif event is InputEventMouseMotion:
		print("Mouse moved in default state")
		#TODO move cursor location
		# but to do that you need to affect the node
		# so you need to give that in the function, if you do it this way