extends Node

var state : CursorState = CursorState.new()


func transition_to(new_state: CursorState) -> void:
	# Transition to a new cursor state
	if state:
		state.on_state_exited()
		print("Exiting state: ", state)
	
	state = new_state
	#state.sprite = $CursorSprite
	state.on_state_entered()
	print("Entering state: ", state)

func _input(event):
	state.on_input(event)

func _process(delta: float) -> void:
	# Process the current state
	if state:
		state.on_process(delta)
	# Update the cursor position to follow the mouse

func _ready():
	# Initialize the cursor state machine
	transition_to(CursorStateDefault.new())
