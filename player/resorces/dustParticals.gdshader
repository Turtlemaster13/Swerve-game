shader_type spatial;

uniform float groundDistance;

void fragment()
{
    vec3 pixel_world_pos = (CAMERA_MATRIX * vec4(VERTEX, 1.0)).xyz;
    pixel_world_pos.y -= groundDistance;
    mat4 WORLD_TO_CLIP_MATRIX = PROJECTION_MATRIX * INV_CAMERA_MATRIX;
    vec4 pixel_clip_pos = WORLD_TO_CLIP_MATRIX * vec4(pixel_world_pos, 1.0);
    vec2 uv = (pixel_clip_pos.xyz / pixel_clip_pos.w).xy * 0.5 + vec2(0.5, 0.5);
    ALBEDO = texture(SCREEN_TEXTURE, uv).rgb;
}
