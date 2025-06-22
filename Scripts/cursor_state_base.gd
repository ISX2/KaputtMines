class_name CursorState

var cursor_sprite: Sprite2D

func on_state_entered() -> void:
	# Called when the state is entered
	pass

func on_state_exited() -> void:
	# Called when the state is exited
	pass

func on_input(event: InputEvent) -> void:
	# Handle input events
	if event is InputEventMouseButton:
		if event.is_pressed():
			pass
		else:
			pass
	elif event is InputEventMouseMotion:
		pass

func on_process(delta: float) -> void:
	# Called every frame while the state is active
	pass