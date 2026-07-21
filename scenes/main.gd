extends Node2D

@export var grid_width: int = 6
@export var grid_height: int = 6
@export var tile_size: int = 64

var grid_array = []
var selected_tile = null
var score: int = 0
var high_score: int = 0
var time_left: int = 60
var score_label: Label
var high_score_label: Label
var timer_label: Label
var game_timer: Timer
var is_busy: bool = false
var game_over: bool = false

# Skoru kalıcı olarak kaydedeceğimiz dosya yolu
const SAVE_PATH = "user://highscore.save"

func _ready() -> void:
	randomize()
	load_high_score() # Oyun açıldığında eski rekoru yükle
	setup_ui()
	setup_timer()
	initialize_grid()

func load_high_score() -> void:
	if FileAccess.file_exists(SAVE_PATH):
		var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
		high_score = file.get_var()
		file.close()
	else:
		high_score = 0

func save_high_score() -> void:
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	file.store_var(high_score)
	file.close()

func setup_ui() -> void:
	score_label = Label.new()
	score_label.position = Vector2(80, 40)
	score_label.text = "Skor: 0"
	score_label.add_theme_font_size_override("font_size", 24)
	add_child(score_label)
	
	high_score_label = Label.new()
	high_score_label.position = Vector2(240, 40)
	high_score_label.text = "Rekor: " + str(high_score)
	high_score_label.add_theme_font_size_override("font_size", 24)
	high_score_label.modulate = Color(1, 0.8, 0.2) # Rekor yazısını altın sarısı yapalım
	add_child(high_score_label)
	
	timer_label = Label.new()
	timer_label.position = Vector2(440, 40)
	timer_label.text = "Süre: 60"
	timer_label.add_theme_font_size_override("font_size", 24)
	add_child(timer_label)

func setup_timer() -> void:
	game_timer = Timer.new()
	game_timer.wait_time = 1.0
	game_timer.autostart = true
	game_timer.timeout.connect(_on_timer_timeout)
	add_child(game_timer)

func _on_timer_timeout() -> void:
	if game_over: return
	
	time_left -= 1
	timer_label.text = "Süre: " + str(time_left)
	
	if time_left <= 0:
		end_game()

func end_game() -> void:
	game_over = true
	game_timer.stop()
	
	# Oyun bittiğinde rekor kırılmışsa diske kaydet
	if score >= high_score:
		save_high_score()
	
	var game_over_label = Label.new()
	if score > high_score:
		game_over_label.text = "SÜRE BİTTİ!\nYENİ REKOR: " + str(score)
		game_over_label.modulate = Color(0.2, 1, 0.2) # Yeni rekor yeşil olsun
	else:
		game_over_label.text = "SÜRE BİTTİ!\nFinal Skor: " + str(score)
		
	game_over_label.add_theme_font_size_override("font_size", 40)
	game_over_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	game_over_label.position = Vector2(120, 250)
	add_child(game_over_label)
	
	for x in range(grid_width):
		for y in range(grid_height):
			var t = get_tile_at(x, y)
			if t:
				t.modulate = Color(0.3, 0.3, 0.3)

func initialize_grid() -> void:
	for child in get_children():
		if child is ColorRect:
			child.queue_free()

	grid_array = []
	for x in range(grid_width):
		grid_array.append([])
		for y in range(grid_height):
			grid_array[x].append(null)

	for x in range(grid_width):
		for y in range(grid_height):
			var t = create_safe_tile(x, y)
			add_child(t)
			grid_array[x][y] = t

	while get_matches().size() > 0:
		for child in get_children():
			if child is ColorRect:
				child.queue_free()

		grid_array = []
		for x in range(grid_width):
			grid_array.append([])
			for y in range(grid_height):
				grid_array[x].append(null)

		for x in range(grid_width):
			for y in range(grid_height):
				var t = create_safe_tile(x, y)
				add_child(t)
				grid_array[x][y] = t

func get_tile_at(x: int, y: int):
	if x >= 0 and x < grid_width and y >= 0 and y < grid_height:
		if grid_array.size() > x and grid_array[x].size() > y:
			var t = grid_array[x][y]
			if t != null and is_instance_valid(t) and not t.is_queued_for_deletion():
				return t
	return null

func create_safe_tile(x: int, y: int) -> ColorRect:
	var tile_instance = ColorRect.new()
	tile_instance.size = Vector2(tile_size - 4, tile_size - 4)
	tile_instance.position = Vector2(x * tile_size + 150, y * tile_size + 100)
	
	var valid_types = [0, 1, 2]
	
	var t_left1 = get_tile_at(x - 1, y)
	var t_left2 = get_tile_at(x - 2, y)
	if t_left1 and t_left2 and t_left1.get_meta("tile_type") == t_left2.get_meta("tile_type"):
		valid_types.erase(t_left1.get_meta("tile_type"))
			
	var t_down1 = get_tile_at(x, y + 1)
	var t_down2 = get_tile_at(x, y + 2)
	if t_down1 and t_down2 and t_down1.get_meta("tile_type") == t_down2.get_meta("tile_type"):
		valid_types.erase(t_down1.get_meta("tile_type"))

	var t_up1 = get_tile_at(x, y - 1)
	var t_up2 = get_tile_at(x, y - 2)
	if t_up1 and t_up2 and t_up1.get_meta("tile_type") == t_up2.get_meta("tile_type"):
		valid_types.erase(t_up1.get_meta("tile_type"))
			
	if valid_types.is_empty():
		valid_types = [0, 1, 2]
		
	var random_type = valid_types[randi() % valid_types.size()]
	
	match random_type:
		0: tile_instance.color = Color(0.9, 0.3, 0.3)
		1: tile_instance.color = Color(0.3, 0.6, 0.9)
		2: tile_instance.color = Color(0.3, 0.8, 0.4)
	
	tile_instance.set_meta("grid_x", x)
	tile_instance.set_meta("grid_y", y)
	tile_instance.set_meta("tile_type", random_type)
	
	tile_instance.mouse_filter = Control.MOUSE_FILTER_STOP
	tile_instance.gui_input.connect(_on_tile_gui_input.bind(tile_instance))
	
	return tile_instance

func _on_tile_gui_input(event: InputEvent, tile: ColorRect) -> void:
	if is_busy or game_over: return
	
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		_on_tile_clicked(tile)

func _on_tile_clicked(tile: ColorRect) -> void:
	if game_over or tile == null or not is_instance_valid(tile) or tile.is_queued_for_deletion(): return
	
	if selected_tile == null:
		selected_tile = tile
		tile.modulate = Color(0.5, 0.5, 0.5)
	else:
		if selected_tile == tile:
			tile.modulate = Color(1, 1, 1)
			selected_tile = null
			return
			
		var x1 = selected_tile.get_meta("grid_x")
		var y1 = selected_tile.get_meta("grid_y")
		var x2 = tile.get_meta("grid_x")
		var y2 = tile.get_meta("grid_y")
		
		var x_diff = abs(x1 - x2)
		var y_diff = abs(y1 - y2)
		
		if is_instance_valid(selected_tile):
			selected_tile.modulate = Color(1, 1, 1)
			
		if (x_diff + y_diff) == 1:
			is_busy = true
			try_swap_and_process(selected_tile, tile)
			
		selected_tile = null

func try_swap_and_process(tile1: ColorRect, tile2: ColorRect) -> void:
	swap_tiles_data(tile1, tile2)
	
	var matches = get_matches()
	if matches.size() > 0:
		process_matches(matches)
	else:
		swap_tiles_data(tile1, tile2)
		is_busy = false

func swap_tiles_data(tile1: ColorRect, tile2: ColorRect) -> void:
	var x1 = tile1.get_meta("grid_x")
	var y1 = tile1.get_meta("grid_y")
	var x2 = tile2.get_meta("grid_x")
	var y2 = tile2.get_meta("grid_y")
	
	grid_array[x1][y1] = tile2
	grid_array[x2][y2] = tile1
	
	tile1.set_meta("grid_x", x2)
	tile1.set_meta("grid_y", y2)
	tile2.set_meta("grid_x", x1)
	tile2.set_meta("grid_y", y1)
	
	var temp_pos = tile1.position
	tile1.position = tile2.position
	tile2.position = temp_pos

func get_matches() -> Array:
	var matched_coords = {}
	
	if grid_array.is_empty(): return []
	
	for y in range(grid_height):
		for x in range(grid_width - 2):
			var t1 = get_tile_at(x, y)
			var t2 = get_tile_at(x + 1, y)
			var t3 = get_tile_at(x + 2, y)
			
			if t1 and t2 and t3:
				if t1.get_meta("tile_type") == t2.get_meta("tile_type") and t2.get_meta("tile_type") == t3.get_meta("tile_type"):
					matched_coords[Vector2(x, y)] = true
					matched_coords[Vector2(x + 1, y)] = true
					matched_coords[Vector2(x + 2, y)] = true

	for x in range(grid_width):
		for y in range(grid_height - 2):
			var t1 = get_tile_at(x, y)
			var t2 = get_tile_at(x, y + 1)
			var t3 = get_tile_at(x, y + 2)
			
			if t1 and t2 and t3:
				if t1.get_meta("tile_type") == t2.get_meta("tile_type") and t2.get_meta("tile_type") == t3.get_meta("tile_type"):
					matched_coords[Vector2(x, y)] = true
					matched_coords[Vector2(x, y + 1)] = true
					matched_coords[Vector2(x, y + 2)] = true
					
	var result = []
	for coord in matched_coords.keys():
		result.append(coord)
	return result

func process_matches(matched_coords: Array) -> void:
	score += matched_coords.size() * 10
	score_label.text = "Skor: " + str(score)
	
	# Anlık skor rekoru geçerse ekrandaki rekor etiketini de anında güncelle
	if score > high_score:
		high_score = score
		high_score_label.text = "Rekor: " + str(high_score)

	for coord in matched_coords:
		var x = int(coord.x)
		var y = int(coord.y)
		var tile = grid_array[x][y]
		
		if tile != null and is_instance_valid(tile):
			tile.queue_free()
		grid_array[x][y] = null

	await get_tree().create_timer(0.15).timeout
	apply_gravity_and_refill()

func apply_gravity_and_refill() -> void:
	for x in range(grid_width):
		var empty := grid_height - 1

		for y in range(grid_height - 1, -1, -1):
			var tile = grid_array[x][y]

			if tile != null and is_instance_valid(tile) and not tile.is_queued_for_deletion():
				if y != empty:
					grid_array[x][empty] = tile
					grid_array[x][y] = null
					tile.set_meta("grid_y", empty)
					tile.position = Vector2(x * tile_size + 150, empty * tile_size + 100)
				empty -= 1

		for y in range(empty, -1, -1):
			var new_tile = create_safe_tile(x, y)
			add_child(new_tile)
			grid_array[x][y] = new_tile

	await get_tree().create_timer(0.15).timeout

	var matches = get_matches()
	if matches.size() > 0:
		process_matches(matches)
	else:
		is_busy = false
