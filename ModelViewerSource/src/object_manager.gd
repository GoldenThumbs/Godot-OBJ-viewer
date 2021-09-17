extends MeshInstance

export(float) var turn_speed : float = 0.25
export(bool) var invert_axis_y : bool = false

onready var gui : Control = get_node("../GUI")

func _ready() -> void:
	var errorCheckMdl = gui.connect("pass_mdl", self, "change_mdl")
	if errorCheckMdl != OK:
		print("Failed to pass model to Object Manager!")
	var errorCheckScale = gui.connect("pass_scale", self, "scale_by_float")
	if errorCheckScale != OK:
		print("Failed to pass scale to Object Manager!")

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		if Input.get_mouse_mode() != Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		if event is InputEventMouseMotion:
			self.rotation_degrees += Vector3(event.relative.y * turn_speed, event.relative.x * turn_speed, 0.0)
	else:
		if Input.get_mouse_mode() != Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func scale_by_float(amnt: float) -> void:
	amnt = max(abs(amnt), 0.01)
	self.scale = Vector3(amnt, amnt, amnt)

func change_mdl(new_mesh: Mesh) -> void:
	self.mesh = new_mesh
