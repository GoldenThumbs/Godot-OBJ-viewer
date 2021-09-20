extends MeshInstance

export(float) var turn_speed : float = 0.25
export(bool) var invert_axis_y : bool = false

var _model_skin : Texture = null
onready var gui : Control = get_node("../GUI")
onready var mat : Material = SpatialMaterial.new()

func _ready() -> void:
	mat.params_specular_mode = SpatialMaterial.SPECULAR_DISABLED
	self.material_override = mat
	var errorCheckMdl := gui.connect("pass_mdl", self, "change_mdl") != OK
	var errorCheckTex := gui.connect("pass_tex", self, "change_tex") != OK
	var errorCheckScale := gui.connect("pass_scale", self, "scale_by_float") != OK
	if errorCheckMdl || errorCheckTex || errorCheckScale:
		print("Error!")

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		if Input.get_mouse_mode() != Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		if event is InputEventMouseMotion:
			self.rotation_degrees += Vector3(event.relative.y * turn_speed, event.relative.x * turn_speed, 0.0)
	else:
		if Input.get_mouse_mode() != Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if Input.is_mouse_button_pressed(BUTTON_RIGHT):
		if event is InputEventMouseMotion:
			self.rotate_z(deg2rad(event.relative.y * turn_speed))

func scale_by_float(amnt: float) -> void:
	amnt = max(abs(amnt), 0.01)
	self.scale = Vector3(amnt, amnt, amnt)

func change_mdl(new_mesh: Mesh) -> void:
	if new_mesh != null:
		self.mesh = new_mesh
	else:
		print("Mesh is NULL")

func change_tex(new_tex: Texture) -> void:
	_model_skin = new_tex
	mat.albedo_texture = _model_skin
