class_name PlayfieldInputController extends Node2D

signal flipper_button_pressed(flipper_direction: Flipper.FlipperDirections)
signal flipper_button_released(flipper_direction: Flipper.FlipperDirections)
signal plunger_button_pressed
signal plunger_button_released

var flip_all_on_press: bool = false

func _physics_process(_delta: float) -> void:
	var press_all := (
		(Input.is_action_just_pressed("left_flippers") or Input.is_action_just_pressed("right_flippers"))
		and flip_all_on_press
		)
	var release_all := (
		(Input.is_action_just_released("left_flippers") or Input.is_action_just_released("right_flippers"))
		and flip_all_on_press
		)
	 
	if press_all:
		print('A start')
		flipper_button_pressed.emit(Flipper.FlipperDirections.ALL)
	else:
		if Input.is_action_just_pressed("left_flippers"):
			print('L start')
			flipper_button_pressed.emit(Flipper.FlipperDirections.LEFT)
		if Input.is_action_just_pressed("right_flippers"):
			print('R start')
			flipper_button_pressed.emit(Flipper.FlipperDirections.RIGHT)
	
	if release_all:
		print('A end')
		flipper_button_released.emit(Flipper.FlipperDirections.ALL)
	else:
		if Input.is_action_just_released("left_flippers"):
			print('L end')
			flipper_button_released.emit(Flipper.FlipperDirections.LEFT)
		if Input.is_action_just_released("right_flippers"):
			print('R end')
			flipper_button_released.emit(Flipper.FlipperDirections.RIGHT)
	
	if Input.is_action_just_pressed("shoot_ball"):
		plunger_button_pressed.emit()
	elif Input.is_action_just_released("shoot_ball"):
		plunger_button_released.emit()
