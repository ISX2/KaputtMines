extends RigidBody2D

enum status {HIDDEN, FLAGGED, REVEALED, CHARRED}

#signal left_clicked(index)
#signal right_clicked(index)

var index: int
var grid_position: Vector2i
var original_position: Vector2
var is_revealed: bool = false
var is_flagged: bool = false
var current_status := status.HIDDEN

var SCALE

func _ready() -> void:
	# Start with physics disabled
	freeze = true
	
	# Configure collision handling
	contact_monitor = true
	
	max_contacts_reported = 4
	
	# Configure input
	input_pickable = true
	connect("input_event", Callable(self, "_on_input_event"))

func setup(texture: Texture2D, region: Rect2, scale_factor: Vector2 = Vector2(1, 1)):
	# Set sprite texture and region
	var sprite = $TileSprite
	sprite.texture = texture
	sprite.region_enabled = true
	sprite.region_rect = region
	
	# Apply scale
	#scale = scale_factor
	#SCALE = scale_factor
	
	# Update collision shape based on texture size
	var collision = $Collision
	#collision.position = Vector2(region.size.x, region.size.y)
	#print(region.size)
	var shape_size = Vector2(region.size.x, region.size.y) * scale_factor
	if collision.shape == null:
		var shape = RectangleShape2D.new()
		shape.set_size(shape_size)
		collision.shape = shape
	else:
		collision.shape.set_size(shape_size)

func update_texture(region: Rect2):
	var sprite = $TileSprite
	sprite.region_rect = region

func activate_physics():
	# Enable physics
	freeze = false
	
	# Disable input
	input_pickable = false
	angular_velocity = (randf() - 0.5) * 10
	apply_central_impulse(Vector2(randf_range(-200, 200), randf_range(-200, -50)))
	# Make it not collide with other tiles
	collision_layer = 2
	collision_mask = 1
	

#func _on_input_event(_viewport, event, _shape_idx):
	#print(_viewport)
	#if freeze:  # Only process input when not in physics mode
		#if event is InputEventMouseButton and event.pressed:
			#if event.button_index == MOUSE_BUTTON_LEFT:
				#emit_signal("left_clicked", index)
			#elif event.button_index == MOUSE_BUTTON_RIGHT:
				#emit_signal("right_clicked", index)

#func _input(event):
	#if freeze:  # Only process input when not in physics mode
		#
		#if event is InputEventMouseButton and event.pressed:
			#print(index)
			##if event.button_index == MOUSE_BUTTON_LEFT:
				##emit_signal("left_clicked", index)
			##elif event.button_index == MOUSE_BUTTON_RIGHT:
				##emit_signal("right_clicked", index)

func _on_body_entered(_body):
	# Handle collisions if needed
	pass
