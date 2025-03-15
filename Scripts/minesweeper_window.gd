extends Control

# The window title and content variables
@export var window_title: String = "Minesweeper"
@export var content_scene: PackedScene

# Movement tracking variables
var dragging: bool = false
var drag_start_position: Vector2
var start_window_position: Vector2

func _ready():
	# Set the window title
	$TitleBar/Title.text = window_title
	
	# If a content scene is specified, instance it
	if content_scene:
		var content_instance = content_scene.instantiate()
		$WindowContent.add_child(content_instance)
	
	# Connect the close button
	$TitleBar/CloseButton.pressed.connect(_on_close_button_pressed)

func _on_title_bar_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				# Start dragging
				dragging = true
				drag_start_position = event.global_position
				start_window_position = global_position
			else:
				# Stop dragging
				dragging = false
	
	elif event is InputEventMouseMotion and dragging:
		# Calculate the new position based on mouse movement
		var new_position = start_window_position + (event.global_position - drag_start_position)
		
		# Ensure the window stays within screen bounds
		new_position.x = clamp(new_position.x, 0, get_viewport_rect().size.x - size.x)
		new_position.y = clamp(new_position.y, 0, get_viewport_rect().size.y - size.y)
		
		# Update the window position
		global_position = new_position

func _on_close_button_pressed():
	# You can either hide the window or remove it
	# For now, we'll just hide it
	hide()
	# If you want to completely remove it:
	# queue_free()

func show_window():
	show()
	# You might want to bring this window to the front:
	# move_to_front()
