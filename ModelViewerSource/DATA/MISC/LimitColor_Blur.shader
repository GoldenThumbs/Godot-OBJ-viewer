shader_type canvas_item;
uniform sampler2D FadeTexture : hint_white;
uniform float Precision = 8.0;
uniform vec4 Tint_Color : hint_color = vec4(1, 1, 1, 1);
uniform float Monochrome = 0.0;
uniform int Sigma = 1;
uniform vec2 Dir = vec2(0.0);

float gauss_weight(int d)
{
	return (0.3989422804014327 / float(Sigma)) * exp(float(-d * d / (2 * Sigma * Sigma)));
}

vec3 BlurColor(sampler2D tex, vec2 texUV)
{
	vec3 sum = vec3(0.0);
	float delta = 1.0 / float(textureSize(tex, 0).x);
	float div = 0.0;
	sum += gauss_weight(0) * texture(tex, texUV).rgb;
	div += gauss_weight(0);
	for (int i = -3 * Sigma; i <= 3 * Sigma; i++)
	{
		sum += gauss_weight(i) * texture(tex, texUV + vec2(delta * float(i)) * Dir).rgb;
		div += 2.0 * gauss_weight(i);
	}
	return sum / div;
}

void fragment() {
	vec3 col = floor(BlurColor(SCREEN_TEXTURE, SCREEN_UV) * Precision) / (Precision - 1.0);
	
	float grayscale = dot(col, vec3(0.5, 0.5, 0.5));
	float white0 = grayscale * 3.0;
	float white1 = clamp(white0 - 2.0, 0, 1);
	
	vec3 fCol = mix(col * Tint_Color.rgb, (grayscale + white1) * Tint_Color.rgb, Monochrome);
	
	vec4 fadeTex = texture(FadeTexture, UV);
	
    COLOR = vec4(fCol * fadeTex.rgb, fadeTex.a * Tint_Color.a);
}