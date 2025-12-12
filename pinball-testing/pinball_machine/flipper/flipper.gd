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

@export var flipper_direction := FlipperDirections.LEFT
@export var flipper_rotation_arc_degrees: float = 60.0
@export var flipper_tween_time_seconds: float = 0.075

#@export var flipper_center_offset_x: float = 32.0

#@export var flipper_starting_rotation_degrees: float = 0
	#set(value):
		#if Engine.is_editor_hint():
			#if !rotation_root: return
			#rotation_root.rotation_degrees = value
		#flipper_starting_rotation_degrees = value

var _is_flipping: bool = false
var _rotate_tween: Tween
var _end_on_finish: bool = false

@onready var rotation_root: Node2D = %RotationRoot
@onready var position_root: StaticBody2D = %PositionRoot
@onready var sprite_2d: Sprite2D = %Sprite2D

#func _physics_process(delta: float) -> void:
	#if Input.is_action_just_pressed("left_flippers"):
		#start_flipper_activation(FlipperDirections.LEFT)
	#if Input.is_action_just_pressed("left_flippers"):
		#start_flipper_activation(FlipperDirections.LEFT)
	#

#func swap_flipper_direction(new_direction: FlipperDirections) -> void:
	#match new_direction:
		#FlipperDirections.LEFT:
			#sprite_2d.flip_h = false
			#position_root.position.x = flipper_center_offset_x
			#if Engine.is_editor_hint():
				#rotation_degrees = -rotation_degrees
		#FlipperDirections.RIGHT:
			#sprite_2d.flip_h = true
			#position_root.position.x = -flipper_center_offset_x
			#if Engine.is_editor_hint():
				#rotation_degrees = -rotation_degrees

func start_flip() -> void:
	if _rotate_tween and _rotate_tween.is_running():
		print('early return')
		return
	else:
		_tween_start_rotation()
		_is_flipping = true

func end_flip() -> void:
	if _rotate_tween and _rotate_tween.is_running():
		print('end on finish')
		_end_on_finish = true
	elif _is_flipping:
		_tween_end_rotation()

#func on_playfield_flippers_deactivated(activated_flipper_direction: FlipperDirections) -> void:
	#if activated_flipper_direction == FlipperDirections.ALL:
		#activate_flipper()
	#else:
		#if activated_flipper_direction == flipper_direction:
			#activate_flipper()

func _tween_start_rotation() -> void:
	_rotate_tween = _create_physics_rotate_tween()
	
	var desired_angle: float = 0.0
	
	match flipper_direction:
		FlipperDirections.LEFT:
			desired_angle = -flipper_rotation_arc_degrees
		FlipperDirections.RIGHT:
			desired_angle = flipper_rotation_arc_degrees
		
	_rotate_tween.tween_property(
		rotation_root, "rotation_degrees", desired_angle, flipper_tween_time_seconds
	)
		#_rotate_tween.tween_property(
			#rotation_root, "rotation_degrees", 0.0, flipper_tween_time_seconds
		#)
	
	await _rotate_tween.finished
	if _end_on_finish:
		_end_on_finish = false
		_tween_end_rotation()
	print('start finished')
	
func _tween_end_rotation() -> void:
	_rotate_tween = _create_physics_rotate_tween()
	
	_rotate_tween.tween_property(
			rotation_root, "rotation_degrees", 0.0, flipper_tween_time_seconds
		)
	
	await _rotate_tween.finished
	_is_flipping = false
	print('end finished')

func _create_physics_rotate_tween() -> Tween:
	var new_tween := create_tween()
	new_tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	
	return new_tween
