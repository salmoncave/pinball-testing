##[Bumper]s in pinball are responsible for altering the typical gameplay that
##happens on a typical playfield.
##[br]
##[br]
##[br]
##This node is intended to be added to a [Playfield] and their functionality
##is determined by [member bumper_type] through [member BumperTypes]
class_name Bumper extends Node2D

enum BumperTypes {
	PASSIVE,
	ACTIVE,
	TRIGGER,
	SWITCH,
}

var bumper_type := BumperTypes.PASSIVE
