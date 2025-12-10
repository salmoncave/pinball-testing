##The [Playfield] is responsible for taking in player input and translating it
##to the playfield that a pinball machine would normally have.
##[br]
##[br]
##[br]
##Each different machine part ([Flipper], [Hole], [Bumper], [Obstacle]) have their
##own [Node] groups. This is because this class is intended to be extended so that
##individual levels can be made up of the constituent parts of a typical pinball machine.
##[br]
##NOTE: This means that every part MUST be placed in the correct position to
##function properly.
class_name Playfield extends Node2D

@onready var flippers: Node2D = %Flippers
@onready var holes: Node2D = %Holes
@onready var bumpers: Node2D = %Bumpers
@onready var obstacles: Node2D = %Obstacles

var left_flippers: Array[Flipper]
var right_flippers: Array[Flipper]

func _ready() -> void:
	set_flippers()

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("left_flippers"):
		activate_flippers(Flipper.FlipperDirections.LEFT)
	if Input.is_action_just_pressed("right_flippers"):
		activate_flippers(Flipper.FlipperDirections.RIGHT)

func activate_flippers(flipper_direction: Flipper.FlipperDirections) -> void:
	var chosen_array: Array[Flipper] = []
	
	match flipper_direction:
		Flipper.FlipperDirections.LEFT:
			chosen_array = left_flippers
		Flipper.FlipperDirections.RIGHT:
			chosen_array = right_flippers
	
	if not chosen_array.is_empty():
		for flipper in chosen_array:
			flipper.activate_flipper()

##Sets up the flippers at the beginning of each level. Will likely need its own
##timing. Integral for setting reference for player input later.
func set_flippers() -> void:
	if flippers.get_child_count() <= 0:
		return
	for child in flippers.get_children():
		if child is Flipper:
			var flipper := child as Flipper
			match flipper.flipper_direction:
				Flipper.FlipperDirections.LEFT:
					left_flippers.append(flipper)
				Flipper.FlipperDirections.RIGHT:
					right_flippers.append(flipper)
