class_name FlipperTileMapLayer extends TileMapLayer

var all_flippers: Array[Flipper]

func _init() -> void:
	child_entered_tree.connect(_on_child_entering_tree)
	child_exiting_tree.connect(_on_child_exiting_tree)

func _on_child_entering_tree(node: Node) -> void:
	if node is Flipper:
		print(node)
		all_flippers.append(node)

func _on_child_exiting_tree(node: Node) -> void:
	if node is Flipper and all_flippers.has(node):
		all_flippers.erase(node)

func _on_playfield_input_controller_flipper_button_pressed(flipper_button_direction: Flipper.FlipperDirections) -> void:
	var flippers_of_direction := _get_flippers_of_direction(flipper_button_direction)
	
	for flipper in flippers_of_direction:
		flipper.start_flip()

func _on_playfield_input_controller_flipper_button_released(flipper_button_direction: Flipper.FlipperDirections) -> void:
	var flippers_of_direction := _get_flippers_of_direction(flipper_button_direction)
	
	for flipper in flippers_of_direction:
		flipper.end_flip()

func _get_flippers_of_direction(flipper_direction: Flipper.FlipperDirections) -> Array[Flipper]:
	var flippers_of_direction: Array[Flipper] = []
	
	if flipper_direction == Flipper.FlipperDirections.ALL:
		flippers_of_direction = all_flippers
	else:
		flippers_of_direction = all_flippers.filter(_filter_flippers_by_direction.bind(flipper_direction))
	
	return flippers_of_direction

func _filter_flippers_by_direction(flipper: Flipper, direction: Flipper.FlipperDirections) -> bool:
	return flipper.flipper_direction == direction
