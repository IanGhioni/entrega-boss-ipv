shader_type canvas_item;

uniform float blur : hint_range(0.0, 6.0) = 2.0;
uniform float brillo : hint_range(0.0, 1.5) = 0.6;

void fragment() {
	vec4 c = textureLod(TEXTURE, UV, blur);
	COLOR = vec4(c.rgb * brillo, c.a);
}