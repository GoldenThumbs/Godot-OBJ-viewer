extends Control

signal pass_mdl(mesh)
signal pass_scale(scale)

onready var toolbar : Control = get_node("Toolbar")
onready var toolbar_body : Control = get_node("Toolbar/Toolbar_Body")
onready var toolbar_tween : Tween = get_node("Toolbar/Toolbar_Tween")
onready var model_dialog : FileDialog = get_node("Model_Dialog")

var toolbar_hidden := true

func _on_Toolbar_mouse_entered() -> void:
	_toggle_toolbar(true)

func _on_Toolbar_mouse_exited() -> void:
	_toggle_toolbar(false)

func _toggle_toolbar(toggle: bool) -> void:
	if toolbar_hidden == toggle:
		toolbar_tween.stop(toolbar_body)
		toolbar_hidden = !toggle
		if toggle:
			var _x := toolbar_body.rect_position.x
			toolbar_tween.interpolate_property(toolbar_body, "rect_position:x", _x, 0, .3, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		else:
			var _x := toolbar_body.rect_position.x
			var _2x := -toolbar_body.get_size().x
			toolbar_tween.interpolate_property(toolbar_body, "rect_position:x", _x, _2x, .3, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		toolbar_tween.start()

func _on_ImportMesh_button_up() -> void:
	model_dialog.popup()

func _on_Model_Dialog_file_selected(path: String) -> void:
	emit_signal("pass_mdl", MdlManager.load_mdl(path))


func _on_ScaleMesh_value_changed(value: float) -> void:
	emit_signal("pass_scale", value)
