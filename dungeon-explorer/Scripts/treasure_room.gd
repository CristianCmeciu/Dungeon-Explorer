extends Control

@onready var room_number:Label = $VBoxContainer/RoomNumber
@onready var item_label: Label = $VBoxContainer/ItemLabel
@onready var action1: Button = $VBoxContainer/Action1
@onready var action2: Button = $VBoxContainer/Action2

var item_chances: Dictionary = {
	"chest": 70,
	"loot": 30
}
func _ready() -> void:
	# Connect button clicks to functions
	action1.pressed.connect(_on_action1_pressed)
	action2.pressed.connect(_on_action2_pressed)
	
	# Generate the random item
	setup_room()

func pick_weighted_item(weights: Dictionary) -> String:
	# Calculate total weight sum
	var total_weight: float = 0.0
	for item in weights:
		total_weight += weights[item]
	
	# Pick a random point between 0 and total_weight
	var roll: float = randf_range(0.0, total_weight)
	
	# Find which item range the roll landed in
	var current_weight: float = 0.0
	for item in weights:
		current_weight += weights[item]
		if roll <= current_weight:
			return item
			
	return weights.keys()[0] # Fallbackc x

func setup_room() -> void:
	# Randomize seed and pick a random item from the list
	randomize()
	var selected_item: String = pick_weighted_item(item_chances)
	var selected_room: int = randi_range(1, 15);
	# Display the item name
	item_label.text = "You found: " + selected_item.capitalize()
	room_number.text = "Room " + str(selected_room)
	
	# Adjust UI depending on whether it's a chest or not
	if selected_item == "chest":
		action1.text = "Open"
		action2.text = "Don't Open"
		action2.show()
	else:
		action1.text = "Collect"
		action2.hide()

func _on_action1_pressed() -> void:
	if action2.visible:
		item_label.text = "You opened the chest!"
	else:
		item_label.text = "You took the item!"

func _on_action2_pressed() -> void:
	item_label.text = "You left the chest alone."
