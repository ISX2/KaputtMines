extends Window

@onready var minesweeper = $Minesweeper

signal left_clicked(position)
signal right_clicked(position)

var mouse_position: Vector2i
#{load MINESWEEPER IN THIS SOMEHOW res://Scripts/minesweeper_boardv2.gd 
#
#FUCK MOVING AND RESIZING ITS A FRIGGIN GAMEJAM
#
#onclick - open menu.tscn
#(idk if we need to put it as current window, I assume this blocks minesweeper automatically)
#
#buttons 
#1 - start game
#2 - quit game

#cat animation is done already
#dialogue start

#func _ready():
	#gui_disable_input = false

func _input(event):
	
	if event is InputEventMouseButton and event.pressed:
		mouse_position = event.position
		if event.button_index == MOUSE_BUTTON_LEFT:
			emit_signal("left_clicked", mouse_position)
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			emit_signal("right_clicked", mouse_position)
		
	
		# Forward the event to your minesweeper node
		#$Minesweeper.input(event)
