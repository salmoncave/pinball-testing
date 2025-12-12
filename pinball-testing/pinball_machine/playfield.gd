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

@onready var playfield_input_controller: PlayfieldInputController = %PlayfieldInputController

@onready var flippers: TileMapLayer = %Flippers
@onready var holes: Node2D = %Holes
@onready var bumpers: Node2D = %Bumpers
@onready var obstacles: Node2D = %Obstacles
@onready var balls: Node2D = %Balls
@onready var plunger: Node2D = %Plunger

@export var split_bumpers: bool = true
@export var debug_pos_nodes: Array[Node2D]
@export var ball_packed_scene: PackedScene

var left_flippers: Array[Flipper]
var right_flippers: Array[Flipper]

func _ready() -> void:
	#_connect_flippers.call_deferred()
	playfield_input_controller.flip_all_on_press = !split_bumpers

#func _physics_process(_delta: float) -> void:
	#if Input.is_action_just_pressed("shoot_ball"):
		#_spawn_ball()
	#if Input.is_action_just_pressed("left_flippers"):
		#activate_flippers(Flipper.FlipperDirections.LEFT)
	#if Input.is_action_just_pressed("right_flippers"):
		#activate_flippers(Flipper.FlipperDirections.RIGHT)
#
#func activate_flippers(flipper_direction: Flipper.FlipperDirections) -> void:
	#if split_bumpers:
		#flippers_activated.emit(flipper_direction)
	#else:
		#flippers_activated.emit(Flipper.FlipperDirections.ALL)
#
###Sets up the flippers at the beginning of each level. Will likely need its own
###timing. Integral for setting reference for player input later.
#func _connect_flippers() -> void:
	#if flippers.get_child_count() <= 0:
		#return
	#for child in flippers.get_children():
		#if child is Flipper:
			#flippers_activated.connect(child.on_playfield_flippers_activated)

func _spawn_ball() -> Ball:
	var new_ball := ball_packed_scene.instantiate() as Ball
	new_ball.global_position = debug_pos_nodes.pick_random().global_position
	balls.add_child(new_ball)
	return new_ball


func _on_playfield_input_controller_plunger_button_pressed() -> void:
	_spawn_ball()
