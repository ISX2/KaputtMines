extends RigidBody2D

@onready var board = $Board
var has_exploded = false
var explosion_force = 300
var explosion_torque = 100
var tile_scene = preload("res://Scenes/physical_tile.tscn")

func _ready():
	freeze = true
	contact_monitor = true
	max_contacts_reported = 4
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	#print("Collision detected with: ", body.name)
	# Check if the body is your floor
	if body.is_in_group("floor") and not has_exploded:
		print("Exploding board!")
		# delay the explosion until after physics processing
		call_deferred("explode_board")

func _physics_process(delta):
	if not has_exploded and not freeze:
		# fallback detection method
		var viewport_height = get_viewport_rect().size.y
		var board_bottom = global_position.y + $BoardCollision.shape.size.y / 2
		
		if board_bottom >= viewport_height:
			print("Reached bottom of screen")  # Debug print
			call_deferred("explode_board")

func start_falling():
	freeze = false

func explode_board():
	if has_exploded:
		return
	
	has_exploded = true
	var board_center = global_position
	
	# Create container for tiles
	var explosion_container = Node2D.new()
	explosion_container.name = "ExplodedTiles"
	get_parent().add_child(explosion_container)
	
	# Get board dimensions and tile set
	var board_width = board.CELL_ROWS
	var board_height = board.CELL_COLUMNS
	var tile_set = board.tile_set
	print(board.scale)
	
	# Create individual tiles
	for y in range(board_height):
		for x in range(board_width):
			var cell_coords = Vector2i(x, y)
			var atlas_coords = board.get_cell_atlas_coords(cell_coords)
			var source_id = board.get_cell_source_id(cell_coords)
			
			if source_id >= 0:  # check if valid cell
				var source = tile_set.get_source(source_id) as TileSetAtlasSource
				if source:
					var tile_instance = tile_scene.instantiate()
					explosion_container.add_child(tile_instance)
					
					# Set up the tile with texture, region and scale
					var region = source.get_tile_texture_region(atlas_coords)
					tile_instance.setup(source.texture, region, board.scale)
					
					# Position the tile
					var local_pos = board.map_to_local(cell_coords)
					tile_instance.global_position = board.to_global(local_pos)
					
					# Calculate and apply explosion forces
					var direction = (tile_instance.global_position - board_center).normalized()
					var random_force = direction * explosion_force * (0.8 + randf() * 0.4)
					tile_instance.apply_central_impulse(random_force)
					
					# Apply random rotation
					var random_torque = (randf() - 0.5) * 2 * explosion_torque
					tile_instance.apply_torque(random_torque)
	
	# Hide the original board
	visible = false
	
	# Optional: Queue free after a delay
	await get_tree().create_timer(5.0).timeout
	queue_free()
