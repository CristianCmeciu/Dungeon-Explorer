extends Node
class_name StatusEffect

var duration: int

func onApply(_target: Node):
	pass

func onTurnOrRoomEnd(_target: Node):
	duration-=1
