shader_type canvas_item;
uniform float Precision = 8.0;
uniform vec4 Tint_Color : hint_color = vec4(1, 1, 1, 1);
uniform float Monochrome = 0.0;

void fragment() {
	vec3 col = floor(texture(SCREEN_TEXTURE, SCREEN_UV).rgb * Precision) / (Precision - 1.0);
	
	float grayscale = dot(col, vec3(0.5, 0.5, 0.5));
	float white0 = grayscale * 3.0;
	float white1 = clamp(white0 - 2.0, 0, 1);
	
	vec3 fCol = mix(col * Tint_Color.rgb, (grayscale + white1) * Tint_Color.rgb, Monochrome);
	
    COLOR = vec4(fCol, Tint_Color.a);
}