##The [Flipper] in a pinball machine is the part responsible rotating to knock
##the [Ball] while it is on the [Playfield]. This class is annotated as tool, to
##allow easy placement and positioning once it is in the editor
@tool
class_name Flipper extends Node2D

enum FlipperDirections {
	LEFT,
	RIGHT, 
}

var flipper_direction := FlipperDirections.LEFT

func change_flipper_direction(new_direction: FlipperDirections) -> void:
	flipper_direction = new_direction
	

func activate_flipper() -> void:
	pass
