extends PanelContainer

@onready var property_container = %VBoxContainer

var frames_per_second : String
var property

# Default is measured in literal seconds.
# Uncapped Frames Config is commented out.

func _ready():
	visible = false
	add_debug_property("Frames Per Second", frames_per_second)

func _input(event):
	if event.is_action_pressed("debug"):
		visible = !visible

func _process(delta):
	#frames_per_second = "%.5f" % (1/delta)
	frames_per_second =  "%.5f" % Engine.get_frames_per_second() 
	property.text = property.name + ": " + frames_per_second

func add_debug_property(title : String,value):
	property = Label.new() # Creates a new label node.
	property_container.add_child(property) # Adds new node as child to Vbox container.
	property.name = title # Set name to title.
	property.text = property.name + value
	
