##The [Flipper] in a pinball machine is the part responsible rotating to knock
##the [Ball] while it is on the [Playfield]. This class is annotated as tool, to
##allow easy placement and positioning once it is in the editor
class_name Flipper extends Node2D

##The directions of the [Flipper], used to determine user input and rotation
##direction
enum FlipperDirections {
	##Used to tell the [Playfield] to activate all flippers instead of distinguishing
	##directions.
	##[br]
	##NOTE: DO NOT use this to set a flipper when creating a [Playfield]. It
	##will just essentially be an [Obstacle]
	ALL,
	##Left Flipper
	LEFT,
	##Right Flipper
	RIGHT, 
}

@export var flipper_direction := FlipperDirections.LEFT:
	set(value):
		if flipper_direction != value:
			if !position_root or !rotation_root:
				await ready
			swap_flipper_direction(value)
		flipper_direction = value

@export var flipper_tween_time_seconds: float = 0.15

@export var flipper_center_offset_x: float = 32.0:
	set(value):
		if Engine.is_editor_hint():
			if !position_root: return
			position_root.position.x = flipper_center_offset_x
		flipper_center_offset_x = value

#@export var flipper_starting_rotation_degrees: float = 0
	#set(value):
		#if Engine.is_editor_hint():
			#if !rotation_root: return
			#rotation_root.rotation_degrees = value
		#flipper_starting_rotation_degrees = value

var _rotate_tween: Tween

@onready var rotation_root: Node2D = %RotationRoot
@onready var position_root: StaticBody2D = %PositionRoot
@onready var sprite_2d: Sprite2D = %Sprite2D

func swap_flipper_direction(new_direction: FlipperDirections) -> void:
	match new_direction:
		FlipperDirections.LEFT:
			sprite_2d.flip_h = false
			position_root.position.x = flipper_center_offset_x
			if Engine.is_editor_hint():
				rotation_degrees = -rotation_degrees
		FlipperDirections.RIGHT:
			sprite_2d.flip_h = true
			position_root.position.x = -flipper_center_offset_x
			if Engine.is_editor_hint():
				rotation_degrees = -rotation_degrees

func on_playfield_flippers_activated(activated_flipper_direction: FlipperDirections) -> void:
	if activated_flipper_direction == FlipperDirections.ALL:
		activate_flipper()
	else:
		if activated_flipper_direction == flipper_direction:
			activate_flipper()

func activate_flipper() -> void:
	if _rotate_tween and _rotate_tween.is_running():
		return
	else:
		_rotate_tween = create_tween()
		
		var desired_angle: float = 0.0
		
		match flipper_direction:
			FlipperDirections.LEFT:
				desired_angle = -90.0
			FlipperDirections.RIGHT:
				desired_angle = 90.0
		
		_rotate_tween.tween_property(
			rotation_root, "rotation_degrees", desired_angle, flipper_tween_time_seconds
		)
		_rotate_tween.tween_property(
			rotation_root, "rotation_degrees", 0.0, flipper_tween_time_seconds
		)
