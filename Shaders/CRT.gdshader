shader_type canvas_item;
render_mode unshaded, skip_vertex_transform;
uniform float curva = 7.0;
uniform float vin_mult = 0.25;
uniform float blur = 0.3;
uniform float scanlines_mult = 2;
//www.youtube.com/@devpoodle
//Делал по видосику этого броу
uniform sampler2D scr_texture: hint_screen_texture, filter_linear_mipmap;
void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec2 center = SCREEN_UV * 2.0 - 1.0;
	vec2 uv_offset = center.yx / curva;
	vec2 warped = center + center * uv_offset * uv_offset;
	vec2 warped_abs = abs(warped);
	vec2 cutoff_smooth = 1.0 - smoothstep(0.99, 1.0, warped_abs);
	vec3 cutoff = vec3(cutoff_smooth.x * cutoff_smooth.y);
	vec3 scanlines = vec3(sin(2.0 * warped.y * 360.0) * scanlines_mult + (1.0 - scanlines_mult)); //Какие синусы... Шейдеры это не мое
	vec3 vingette = vec3(length(pow(abs(center), vec2(4.0)) / 3.0));
	vec3 scr_color = textureLod(scr_texture, (warped + 1.0) / 2.0, blur).rgb * cutoff * scanlines;
	scr_color -= vingette * vin_mult;
	COLOR = vec4(scr_color, 1.0);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
