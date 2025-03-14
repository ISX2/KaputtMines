extends Node2D

const CELL_ROWS := 30
const CELL_COLUMNS := 16
const MINE_COUNT := 99
const TILE_SIZE := 32

# Texture atlas constants
const TILE_ATLAS_COLS := 4
const TILE_ATLAS_ROWS := 4
const TILE_WIDTH := 16
const TILE_HEIGHT := 16

# Texture coordinates (in atlas grid positions)
const HIDDEN_TILE := Vector2i(0, 0)
const FLAG_TILE := Vector2i(1, 0)
const QUESTION_TILE := Vector2i(2, 0)
const EMPTY_TILE := Vector2i(1, 4)
const NUM1_TILE := Vector2i(0, 1)
const NUM2_TILE := Vector2i(1, 1)
const NUM3_TILE := Vector2i(2, 1)
const NUM4_TILE := Vector2i(3, 1)
const NUM5_TILE := Vector2i(0, 2)
const NUM6_TILE := Vector2i(1, 2)
const NUM7_TILE := Vector2i(2, 2)
const NUM8_TILE := Vector2i(3, 2)
const MINE_TILE := Vector2i(0, 3)
const MINE_RED_TILE := Vector2i(1, 3)
const MINE_X_TILE := Vector2i(2, 3)
const MINE_CHECK_TILE := Vector2i(3, 3)

var tile_scene = preload("res://Scenes/physical_tile.tscn")
var tiles = []  # Array to store all tile instances
var cells = []  # Array to store game data (-1=empty, 0=mine, 1-8=number)
var gameEnded := false
var firstClick := true

# Texture
var tile_texture: Texture2D

func _ready() -> void:
	# Load the tile atlas texture
	tile_texture = load("res://assets/Tile - 2.png")  # Path to your tile atlas
	setUpBoard()

func get_tile_region(coords: Vector2i) -> Rect2:
	# Convert grid coordinates to pixel coordinates in the atlas
	return Rect2(
		coords.x * TILE_WIDTH, 
		coords.y * TILE_HEIGHT, 
		TILE_WIDTH, 
		TILE_HEIGHT
	)

func setUpBoard() -> void:
	# Initialize cells array
	cells.clear()
	for i in range(CELL_ROWS * CELL_COLUMNS):
		cells.append(-1)
	
	# Create all tiles
	for y in range(CELL_COLUMNS):
		for x in range(CELL_ROWS):
			var tile_instance = tile_scene.instantiate()
			add_child(tile_instance)
			
			# Set position
			tile_instance.position = Vector2(x * TILE_SIZE, y * TILE_SIZE)
			
			# Set up the tile with texture and region
			tile_instance.setup(tile_texture, get_tile_region(HIDDEN_TILE))
			
			# Store reference to tile
			tiles.append(tile_instance)
			
			# Set tile data
			var index = getCellIndex(Vector2i(x, y))
			tile_instance.index = index
			tile_instance.grid_position = Vector2i(x, y)
			
			# Connect signals
			tile_instance.connect("left_clicked", Callable(self, "_on_tile_left_clicked"))
			tile_instance.connect("right_clicked", Callable(self, "_on_tile_right_clicked"))

func setUpMines(avoid: Vector2i) -> void:
	# Place mines
	for i in range(MINE_COUNT):
		cells[i] = 0
	
	cells.shuffle()
	
	# Make sure no mines are placed near the first click
	while getSurroundingCells(avoid, 5).has(0):
		cells.shuffle()
	
	# Calculate numbers
	for y in range(CELL_COLUMNS):
		for x in range(CELL_ROWS):
			if cells[getCellIndex(Vector2i(x, y))] != 0:
				var mineCount := 0
				for i in getSurroundingCells(Vector2i(x, y), 3):
					if i == 0:
						mineCount += 1
				if mineCount > 0:
					cells[getCellIndex(Vector2i(x, y))] = mineCount

func _on_tile_left_clicked(index: int) -> void:
	var tile = tiles[index]
	var grid_position = tile.grid_position
	
	if gameEnded:
		return
	
	if firstClick:
		firstClick = false
		setUpMines(grid_position)
	
	revealCell(grid_position)
	
	if cells[index] == 0:
		gameEnded = true
		revealAllMines(grid_position)

func _on_tile_right_clicked(index: int) -> void:
	var tile = tiles[index]
	
	if gameEnded or tile.is_revealed:
		return
	
	if tile.is_flagged:
		# Change to question mark (if you want)
		tile.is_flagged = false
		tile.update_texture(get_tile_region(HIDDEN_TILE))
	else:
		# Flag tile
		tile.is_flagged = true
		tile.update_texture(get_tile_region(FLAG_TILE))

func revealCell(cellCoords: Vector2i) -> void:
	var cellIndex = getCellIndex(cellCoords)
	if cellIndex < 0 or cellIndex >= cells.size():
		return
	
	var tile = tiles[cellIndex]
	if tile.is_revealed or tile.is_flagged:
		return
	
	tile.is_revealed = true
	
	# Set texture based on cell value
	match cells[cellIndex]:
		-1: # Empty
			tile.update_texture(get_tile_region(EMPTY_TILE))
			# Reveal surrounding cells
			revealSurroundingCells(cellCoords)
		0: # Mine
			tile.update_texture(get_tile_region(MINE_RED_TILE))
		1: tile.update_texture(get_tile_region(NUM1_TILE))
		2: tile.update_texture(get_tile_region(NUM2_TILE))
		3: tile.update_texture(get_tile_region(NUM3_TILE))
		4: tile.update_texture(get_tile_region(NUM4_TILE))
		5: tile.update_texture(get_tile_region(NUM5_TILE))
		6: tile.update_texture(get_tile_region(NUM6_TILE))
		7: tile.update_texture(get_tile_region(NUM7_TILE))
		8: tile.update_texture(get_tile_region(NUM8_TILE))

func getCellIndex(cellCoords: Vector2i) -> int:
	if cellCoords.x < 0 or cellCoords.x >= CELL_ROWS or cellCoords.y < 0 or cellCoords.y >= CELL_COLUMNS:
		return -1
	return cellCoords.y * CELL_ROWS + cellCoords.x

func getSurroundingCells(cellCoords: Vector2i, size: int) -> Array:
	var surroundingCells = []
	for y in range(-1, size-1):
		for x in range(-1, size-1):
			var offsetCoords = cellCoords + Vector2i(x, y)
			var index = getCellIndex(offsetCoords)
			if index >= 0 and index < cells.size():
				surroundingCells.append(cells[index])
			else:
				surroundingCells.append(-1)
	return surroundingCells

func revealSurroundingCells(cellCoords: Vector2i) -> void:
	for y in range(-1, 2):
		for x in range(-1, 2):
			var offsetCoords = cellCoords + Vector2i(x, y)
			var index = getCellIndex(offsetCoords)
			if index >= 0 and index < tiles.size():
				var tile = tiles[index]
				if not tile.is_revealed and not tile.is_flagged:
					revealCell(offsetCoords)

func revealAllMines(exploded_position: Vector2i) -> void:
	for y in range(CELL_COLUMNS):
		for x in range(CELL_ROWS):
			var cellCoords = Vector2i(x, y)
			var index = getCellIndex(cellCoords)
			if cells[index] == 0:
				var tile = tiles[index]
				if cellCoords == exploded_position:
					# This is the mine that was clicked
					tile.update_texture(get_tile_region(MINE_RED_TILE))
				elif tile.is_flagged:
					# Correctly flagged mine
					tile.update_texture(get_tile_region(MINE_CHECK_TILE))
				else:
					# Regular mine
					tile.update_texture(get_tile_region(MINE_TILE))
	
	# Start the explosion effect
	explode_board()

func explode_board() -> void:
	# Start with a small delay
	await get_tree().create_timer(0.5).timeout
	
	# Make all tiles fall with physics
	for tile in tiles:
		tile.activate_physics()
		
		# Apply explosion force
		var direction = (tile.global_position - global_position).normalized()
		var distance = tile.global_position.distance_to(global_position)
		var force = direction * (300 / max(1, distance * 0.1)) * (0.8 + randf() * 0.4)
		tile.apply_central_impulse(force)
		
		# Apply random rotation
		var random_torque = (randf() - 0.5) * 2 * 100
		tile.apply_torque(random_torque)
