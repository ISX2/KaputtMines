# In your main game scene (desktop environment):

extends Node2D

# Load your window scene and minesweeper scene
var window_scene = preload("res://Scenes/minesweeper_window.tscn")
var minesweeper_scene = preload("res://Scenes/minesweeper.tscn")
func _ready():
	# Create minesweeper window
	create_minesweeper_window()

func create_minesweeper_window():
	var window = window_scene.instantiate()
	add_child(window)
	
	# Set window properties
	window.window_title = "Minesweeper"
	window.content_scene = minesweeper_scene
	
	# Position the window somewhere on the screen
	window.position = Vector2(100, 100)
	
	# If you want to create the window with a specific size
	# (Note: this doesn't allow runtime resizing, just initial setup)
	var window_size = Vector2(350, 450)  # Adjust to fit your minesweeper game
	window.get_node("Panel").custom_minimum_size = window_size
	window.get_node("WindowContent").custom_minimum_size = Vector2(window_size.x, window_size.y - 30)  # Subtract title bar height
