extends Node

const CURSOR_SHAPE_TEXTURES: Dictionary = {
	Input.CursorShape.CURSOR_CROSS: preload("res://resources/cursors/cross.png"),
	# last cursor becomes default on start up
	Input.CursorShape.CURSOR_ARROW: preload("res://resources/cursors/arrow.png"),
}

var _cursor_scale: Vector2i = Vector2i.ONE:
	set = _set_cursor_scale
var _scaled_cursor_shape_textures: Dictionary = {}

func _ready() -> void:
	get_viewport().size_changed.connect(_on_viewport_size_changed)
	_on_viewport_size_changed()
	_set_cursor_scale(_cursor_scale)


func _set_cursor_scale(p_value: Vector2i) -> void:
	_cursor_scale = p_value
	
	for cursor_shape in CURSOR_SHAPE_TEXTURES.keys():
		var texture: Texture2D = null
		if _scaled_cursor_shape_textures.get(cursor_shape, {}).get(_cursor_scale):
			texture = _scaled_cursor_shape_textures[cursor_shape][_cursor_scale]
		else:
			if _cursor_scale == Vector2i.ONE:
				texture = CURSOR_SHAPE_TEXTURES[cursor_shape]
			else:
				var image: Image = CURSOR_SHAPE_TEXTURES[cursor_shape].get_image()
				image.resize(image.get_width() * _cursor_scale.x, image.get_height() * _cursor_scale.y, Image.INTERPOLATE_NEAREST)
				texture = ImageTexture.create_from_image(image)
			
			if not _scaled_cursor_shape_textures.has(cursor_shape):
				_scaled_cursor_shape_textures[cursor_shape] = {}
			_scaled_cursor_shape_textures[cursor_shape][_cursor_scale] = texture
		
		Input.set_custom_mouse_cursor(texture, cursor_shape)


func _on_viewport_size_changed() -> void:
	var scale: Vector2i = (Vector2i(get_window().get_final_transform().get_scale()) / 2)# / DisplayServer.screen_get_scale()
	
	if _cursor_scale != scale:
		_set_cursor_scale(scale)
