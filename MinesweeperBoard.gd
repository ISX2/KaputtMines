extends TileMapLayer

const CELL_ROWS := 30
const CELL_COLUMNS := 16
const MINE_COUNT:= 99

# -1  = empty cell
# 0 = mine
# 1-8 = number cell\
var cells : Array[int]
var surroundingCells : Array[int]
var offsetCoords : Vector2i

var gameEnded : bool

func _ready() -> void:
	setUpBoard()
	
func setUpBoard() -> void:
	for y in range(CELL_COLUMNS):
		for x in range(CELL_ROWS):
			set_cell( Vector2i(x,y), 0, Vector2i(0,0))
			cells.append(-1)
	
func setUpMines(avoid: Vector2i) -> void:
	for i in range(MINE_COUNT):
		cells[i] = 0
		
	cells.shuffle()
	
	while getSurroundingCells(avoid, 5).has(0):
		cells.shuffle()
		
	for y in range(CELL_COLUMNS):
		for x in range(CELL_ROWS):
			if not cells[getCellIndex(Vector2i(x,y))] == 0:
				var mineCount := 0 
				for i in getSurroundingCells(Vector2i(x,y), 3):
					if i == 0:
						mineCount += 1
				if mineCount > 0:
					cells[getCellIndex(Vector2i(x,y))] = mineCount

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("reveal"):
		var cellAtMouse : Vector2i = local_to_map(get_local_mouse_position())
		if cells.has(0):
			revealCell(cellAtMouse)
			
			if cells[getCellIndex(cellAtMouse)] == 0:
				gameEnded = true
				revealAllMines(cellAtMouse)
		else:
			setUpMines(cellAtMouse)
			revealCell(cellAtMouse)
	if event.is_action_pressed("flag"):
		var cellAtMouse : Vector2i = local_to_map(get_local_mouse_position())
		print(getAtlasCoords(cellAtMouse) == Vector2i(0, 0))
		if getAtlasCoords(cellAtMouse) == Vector2i(0, 0):
			set_cell(cellAtMouse, 0, Vector2i(1, 0))
		elif getAtlasCoords(cellAtMouse) == Vector2i(1, 0):
			set_cell(cellAtMouse, 0, Vector2i(0, 0))
		
	
func revealCell(cellCoords: Vector2i) -> void:
	var cellIndex : int = getCellIndex(cellCoords)
	
	var atlasCoords : Vector2i
	#switch case!
	match cells[cellIndex] :
		-1 : atlasCoords = Vector2i(3, 0) #empty
		0 : atlasCoords = Vector2i(0, 3) #Mine
		1 : atlasCoords = Vector2i(0, 1) #Number Cells
		2 : atlasCoords = Vector2i(1, 1) 
		3 : atlasCoords = Vector2i(2, 1) 
		4 : atlasCoords = Vector2i(3, 1) 
		5 : atlasCoords = Vector2i(0, 2) 
		6 : atlasCoords = Vector2i(1, 2)
		7 : atlasCoords = Vector2i(2, 2)
		8 : atlasCoords = Vector2i(3, 2)
		
	set_cell(cellCoords, 0, atlasCoords)
	
	if cells[cellIndex] == -1:
		revealSurroundingCells(cellCoords)
	
func getCellIndex(cellCoords: Vector2i) -> int:
	if cellCoords.x < CELL_ROWS and cellCoords.y < CELL_COLUMNS and cellCoords.x >= 0 and cellCoords.y >= 0:
		return cellCoords.y * CELL_ROWS + cellCoords.x
	return -1
	
func getSurroundingCells(cellCoords: Vector2i, size : int) -> Array[int]:
	surroundingCells = []
	for y in range(-1,size-1):
		for x in range(-1, size-1):
			offsetCoords = cellCoords + Vector2i(x, y)
			if getCellIndex(offsetCoords) > -1:
				surroundingCells.append(cells[getCellIndex(offsetCoords)])
			else:
				surroundingCells.append(-1)
	return surroundingCells
	
func revealSurroundingCells(cellCoords: Vector2i) -> void:
	for y in range(-1, 2):
		for x in range(-1, 2):
			offsetCoords = cellCoords + Vector2i(x,y)
			if getCellIndex(offsetCoords) > -1 and (getAtlasCoords(offsetCoords) == Vector2i(0, 0) or getAtlasCoords(offsetCoords) == Vector2i(1, 0)):
				revealCell(offsetCoords)
			
func getAtlasCoords(cellCoords: Vector2i) -> Vector2i:
	return get_cell_atlas_coords(cellCoords)
				
			

func revealAllMines(avoid: Vector2i) -> void:
	var cellCoords : Vector2i
	for y in range(CELL_COLUMNS):
		for x in range(CELL_ROWS):
			cellCoords = Vector2i(x,y)
			if cells[getCellIndex(cellCoords)] == 0:
				if not cellCoords == avoid:
					set_cell(cellCoords, 0, Vector2i(2, 0))
				else:
					if getAtlasCoords(cellCoords) == Vector2i(1, 0):
						set_cell(cellCoords, 0, Vector2i(1, 3))
	
