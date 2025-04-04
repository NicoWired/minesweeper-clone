shader_type canvas_item;

// Glow color
uniform vec4 glow_color : source_color = vec4(1.0, 1.0, 0.0, 1.0);
// Glow intensity (0.0 - 1.0)
uniform float glow_intensity : hint_range(0.0, 1.0) = 0.0;
// Glow width in pixels
uniform float glow_width : hint_range(0.0, 10.0) = 2.0;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec4 original_color = texture(TEXTURE, UV);

	// Start with the original color
	COLOR = original_color;

	// If this pixel has some transparency, check if it should be part of the outline
	if (original_color.a < 0.98) {
		// Sample in 8 directions to find edges
		float outline_alpha = 0.0;
		float size = glow_width * TEXTURE_PIXEL_SIZE.x;

		// Sample in neighboring pixels to detect edges
		outline_alpha += texture(TEXTURE, UV + vec2(size, 0.0)).a;
		outline_alpha += texture(TEXTURE, UV + vec2(-size, 0.0)).a;
		outline_alpha += texture(TEXTURE, UV + vec2(0.0, size)).a;
		outline_alpha += texture(TEXTURE, UV + vec2(0.0, -size)).a;
		outline_alpha += texture(TEXTURE, UV + vec2(size, size)).a;
		outline_alpha += texture(TEXTURE, UV + vec2(-size, size)).a;
		outline_alpha += texture(TEXTURE, UV + vec2(size, -size)).a;
		outline_alpha += texture(TEXTURE, UV + vec2(-size, -size)).a;

		// If any surrounding pixels have alpha, and current pixel has less alpha
		// then this pixel should be part of the outline
		if (outline_alpha > 0.0 && original_color.a < 0.5) {
			// Apply glow color with reduced alpha for nice falloff
			float final_alpha = min(outline_alpha * glow_intensity * (1.0 - original_color.a), 1.0);
			COLOR = mix(COLOR, glow_color, final_alpha);
		}
	}
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
