extends Control

signal pass_mdl(mesh)
signal pass_tex(tex)
signal pass_scale(scale)

onready var toolbar : Control = get_node("Toolbar")
onready var toolbar_body : Control = get_node("Toolbar/Toolbar_Body")
onready var toolbar_tween : Tween = get_node("Toolbar/Toolbar_Tween")
onready var model_dialog : FileDialog = get_node("Model_Dialog")
onready var texture_dialog : FileDialog = get_node("Texture_Dialog")
onready var texture_display : TextureRect = get_node("Texture_Display")

var toolbar_hidden := true

func _on_Toolbar_Toggle_toggled(button_pressed: bool) -> void:
	_toggle_toolbar(button_pressed)

func _toggle_toolbar(toggle: bool) -> void:
	if toolbar_hidden == toggle:
		var _start = toolbar_tween.stop(toolbar_body)
		toolbar_hidden = !toggle
		if toggle:
			print("Sliding In!")
			var _x := toolbar_body.rect_position.x
			var _tween = toolbar_tween.interpolate_property(toolbar_body, "rect_position:x", _x, 0, .3, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		else:
			print("Sliding Out!")
			var _x := toolbar_body.rect_position.x
			var _2x := -toolbar_body.get_size().x
			var _tween = toolbar_tween.interpolate_property(toolbar_body, "rect_position:x", _x, _2x, .3, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		var _stop = toolbar_tween.start()

func _on_ImportMesh_button_up() -> void:
	model_dialog.popup()

func _on_Model_Dialog_file_selected(path: String) -> void:
	emit_signal("pass_mdl", MdlManager.load_mdl(path))

func _on_ScaleMesh_value_changed(value: float) -> void:
	emit_signal("pass_scale", value)

func _on_SelectTex_button_up() -> void:
	texture_dialog.popup()

func _on_Texture_Dialog_file_selected(path: String) -> void:
	var tmpImage = Image.new()
	var errorCheck = tmpImage.load(path)
	if errorCheck != OK:
		print("Failed to load image!")
	else:
		var modelSkin = ImageTexture.new()
		modelSkin.create_from_image(tmpImage, 18)
		emit_signal("pass_tex", modelSkin)
		texture_display.texture = modelSkin
		print("Selected Texture from path[", path,"]")
