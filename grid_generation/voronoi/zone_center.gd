class_name ZoneCenter

var _coords: Vector2i
var _zone_type: int

var coords: Vector2i:
	get:
		return _coords

var zone_type: int:
	get:
		return _zone_type

func _init(pos: Vector2i, zone: int):
	_coords = pos
	_zone_type = zone