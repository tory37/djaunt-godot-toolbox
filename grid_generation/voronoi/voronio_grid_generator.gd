class_name VoronoiGridGenerator

var _zone_centers: Array[ZoneCenter] = []
var _grid_array: Array[int] = []  # 1D array for world data storage
var _grid_size: int
var _grid_radius: int
var _num_centers: int
var _num_zones: int
var _smooth_iterations: int = 1
var _smooth_radius: int = 1
var _should_wrap_grid: bool = false
var _wrap_grid_size: int = 0
var _wrap_grid_zone: int = -1

var _warp_noise = FastNoiseLite.new()

func _init(
	grid_size: int, 
	num_zones: int, 
	num_centers: int, 
	warp_frequency: float = 0.01, 
	smooth_iterations: int = 1, 
	smooth_radius: int = 1,
	wrap_grid: bool = false,
	wrap_grid_size: int = 0,
	wrap_grid_zone: int = -1
):
	_grid_size = grid_size
	_grid_radius = grid_size / 2
	_num_zones = num_zones
	_num_centers = num_centers

	_warp_noise.seed = randi()
	_warp_noise.frequency = warp_frequency
	_warp_noise.noise_type = FastNoiseLite.TYPE_SIMPLEX	

	_smooth_iterations = smooth_iterations
	_smooth_radius = smooth_radius

	_should_wrap_grid = wrap_grid
	_wrap_grid_size = wrap_grid_size
	_wrap_grid_zone = wrap_grid_zone

var grid: Array[int]:
	get:
		return _grid_array

var radius: int:
	get:
		return _grid_radius

# Public API
func generate_grid():
	"""
	Generate the entire grid and save it to disk.
	"""
	print("Generating grid (%dx%d coords)..." % [_grid_size, _grid_size])
	
	var start_time = Time.get_ticks_msec()
	var total_coords = _grid_size * _grid_size

	var progress_interval = total_coords / 100  # Progress every 1%
	
	# Initialize array with default zone (grass)
	_grid_array.resize(total_coords)
	_grid_array.fill(_wrap_grid_zone if _should_wrap_grid else 0)

	_generate_zone_centers(_num_centers, _grid_size, _grid_size)
	
	for x in range(-_grid_radius, _grid_radius):
		for y in range(-_grid_radius, _grid_radius):
			var zone_int: int = _get_zone_for_coords(x, y)
			_store_coords_data(x, y, zone_int)
			
			# Progress reporting
			var coords_count = (x + _grid_radius) * _grid_size + (y + _grid_radius)
			if coords_count % progress_interval == 0:
				var progress = (coords_count * 100) / total_coords
				print("World generation progress: %d%%" % progress)
	
	for i in range(_smooth_iterations):
		print("Smoothing zones (%d/%d)..." % [i + 1, _smooth_iterations])
		_smooth_zones()

	_final_cleanup()

	if _should_wrap_grid:
		_wrap_grid()

	var generation_time = Time.get_ticks_msec() - start_time
	print("World generation complete! Took %d seconds" % (generation_time / 1000))
	print("Generated %d coords" % _grid_array.size())
	
func load_grid(grid_array: Array[int]):
	_grid_array.clear()
	_grid_array.resize(grid_array.size())
	for i in range(grid_array.size()):
		_grid_array[i] = grid_array[i]

func get_zone_for_coords(x_coord: int, y_coord: int) -> int:
	"""
	Get the zone of a coords as a string.
	"""
	if not is_within_bounds(x_coord, y_coord):
		return -1
	
	var index = grid_coords_to_index(x_coord, y_coord)
	var zone_int = _grid_array[index]
	return zone_int

func grid_coords_to_index(x: int, y: int) -> int:
	"""
	Convert 2D world coordinates to 1D array index.
	Coordinates range from -_grid_radius to _grid_radius-1
	"""
	var minX = -_grid_radius
	var minY = -_grid_radius
	var width = _grid_size
	return (y - minY) * width + (x - minX)

func is_within_bounds(x_coord: int, y_coord: int) -> bool:
	"""
	Check if coordinates are within the world bounds.
	"""
	return x_coord >= -_grid_radius and x_coord < _grid_radius and \
			 y_coord >= -_grid_radius and y_coord < _grid_radius

# Private
func _generate_zone_centers(num_centers: int, map_width: int, map_height: int):
	_zone_centers.clear()
	for i in range(num_centers):
		# Generate centers in the same coordinate system as the world coords
		var pos = Vector2i(randi_range(-_grid_radius, _grid_radius-1), randi_range(-_grid_radius, _grid_radius-1))
		var zone = randi() % _num_zones
		print("zone center %d: %s at %s" % [i, zone, pos])
		_zone_centers.append(ZoneCenter.new(pos, zone))

func _get_zone_for_coords(x: int, y: int):
	var offset_x = _warp_noise.get_noise_2d(x, y) * 10.0
	var offset_y = _warp_noise.get_noise_2d(x + 10000, y + 10000) * 10.0
	var warped_point = Vector2(x + offset_x, y + offset_y)

	var closest_dist = INF
	var closest_zone = null
	for center in _zone_centers:
		var dist = warped_point.distance_squared_to(center.coords)
		if dist < closest_dist:
			closest_dist = dist
			closest_zone = center.zone_type
	return closest_zone

func _get_coords_neighbors(x: int, y: int, radius: int = 1) -> Array[int]:
	var neighbors: Array[int] = []
	for x_offset in range(-radius, radius + 1):
		for y_offset in range(-radius, radius + 1):
			if x_offset == 0 and y_offset == 0:
				continue
			var neighbor_x = x + x_offset
			var neighbor_y = y + y_offset
			if is_within_bounds(neighbor_x, neighbor_y):
				neighbors.append(_grid_array[grid_coords_to_index(neighbor_x, neighbor_y)])
	return neighbors

func _most_common(neighbors: Array[int]) -> int:
	var counts: Dictionary[int, int] = {}
	for neighbor in neighbors:
		counts[neighbor] = counts.get(neighbor, 0) + 1
	
	# Find the key with the highest value
	var max_count = 0
	var max_key = 0
	for key in counts:
		if counts[key] > max_count:
			max_count = counts[key]
			max_key = key
	return max_key

func _smooth_zones():
	var new_map: Array[int] = _grid_array.duplicate()
	for x in range(-_grid_radius, _grid_radius):
		for y in range(-_grid_radius, _grid_radius):
			var zone = _grid_array[grid_coords_to_index(x, y)]
			var neighbors = _get_coords_neighbors(x, y)
			var majority = _most_common(neighbors)
			if majority != zone:
				new_map[grid_coords_to_index(x, y)] = majority
	_grid_array = new_map

func _final_cleanup():
	var final_map: Array[int] = _grid_array.duplicate()
	for x in range(-_grid_radius, _grid_radius):
		for y in range(-_grid_radius, _grid_radius):
			var index = grid_coords_to_index(x, y)
			var zone = _grid_array[index]
			var neighbors = _get_coords_neighbors(x, y)
			var majority = _most_common(neighbors)
			
			# If the coords's zone is NOT the majority, overwrite it
			if zone != majority and neighbors.count(zone) < 4:
				final_map[index] = majority

	_grid_array = final_map

func _wrap_grid():
	for x in range(-_grid_radius, _grid_radius):
		for y in range(-_grid_radius, _grid_radius):
			if x < (-_grid_radius + _wrap_grid_size) or x > (_grid_radius - _wrap_grid_size) or y < (-_grid_radius + _wrap_grid_size) or y > (_grid_radius - _wrap_grid_size):
				var index = grid_coords_to_index(x, y)
				_grid_array[index] = _wrap_grid_zone

func _store_coords_data(x_coord: int, y_coord: int, zone: int):
	# Store zone as integer in 1D array
	var index = grid_coords_to_index(x_coord, y_coord)
	_grid_array[index] = zone

# zone
func _update_coords_zone(x_coord: int, y_coord: int, new_zone: int):
	"""
	Change a coords's zone at runtime.
	"""
	if new_zone < 0 or new_zone >= _num_centers:
		print("ERROR: Invalid zone: %s" % new_zone)
		return
	
	_store_coords_data(x_coord, y_coord, new_zone)
	
	# Emit signal for other systems to react
	SignalBus.coords_zone_changed.emit(x_coord, y_coord, new_zone)
