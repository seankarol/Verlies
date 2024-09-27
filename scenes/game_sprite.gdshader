shader_type canvas_item;

uniform bool active;
uniform vec3 flash_color : source_color = vec3(1.0);

uniform bool palette_swap;
uniform vec4 palette_src : source_color  = vec4(0.0);
uniform vec4 palette_dst : source_color  = vec4(0.0);

void fragment(){
	vec4 t = texture(TEXTURE, UV);
	if (palette_swap && t.a > 0.0) {
		if(distance(COLOR, palette_src) < 0.1)
		{
			COLOR = palette_dst;
		}
	}
	
	if (active == true) {
		COLOR = vec4(flash_color, t.a);
	}
}