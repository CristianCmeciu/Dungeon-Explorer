extends Node2D

signal room_completed(next_event: String)
signal room_died

@export var doors: Array[Area2D]
@export var event_label: Label
@export var fake_door_label: Label
@export var fight_scene: PackedScene

var currentEvent: Node2D

var thresholds = [15, 35, 60, 70, 75, 80, 90, 100]
var events = [
	"nimic", "minion room", "treasure room", "usa fache", 
	"witch fight", "trap room", "mimic fight", "skeleton fight"
]

func setup(my_event: String):
	
	if event_label:
		event_label.text = "Event: " + my_event
		
	if my_event == "mimic fight":
		currentEvent = fight_scene.instantiate()
		self.add_child(currentEvent)
		currentEvent.generateEnemy(my_event)
		currentEvent.exitFight.connect(fightWon)
		
	if my_event == "trap room":
		room_died.emit()
		return 
		
	for door in doors:
		var future_event = get_random_event()
		future_event = "mimic fight"
		door.set_target_event(future_event)
		door.clicked.connect(_on_door_clicked)
		door.fake_clicked.connect(_on_fake_door_clicked)
	
	if fake_door_label:
		fake_door_label.hide()
	
	if my_event == "usa fache":
		setup_fake_doors()

func setup_fake_doors():
	
	if doors.size() == 2:
		var fake_index = randi() % 2
		doors[fake_index].is_fake = true
		
	elif doors.size() == 3:
		var num_fakes = randi() % 2
		
		if num_fakes:
			doors[1].is_fake = true
			var other_fake = 0 if randi() % 2 else 2
			doors[other_fake].is_fake = true
			
		else:
			var fake_index = randi() % 3
			doors[fake_index].is_fake = true
			
func get_random_event() -> String:
	
	var roll = randi_range(1, 100)
	var index = thresholds.bsearch(roll)
	index = clampi(index, 0, events.size() - 1)
	return events[index]

func _on_door_clicked(event_passed_from_door: String):
	
	room_completed.emit(event_passed_from_door)

func _on_fake_door_clicked():
	
	if fake_door_label:
		fake_door_label.show()
		
		var tween = create_tween()
		tween.tween_interval(0.2)
		tween.tween_callback(func():
			if is_instance_valid(fake_door_label):fake_door_label.hide())
		
func fightWon():
	currentEvent.queue_free()
