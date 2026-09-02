shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, filter_linear;

// ===== DALTONISMO =====
uniform int filter_mode : hint_range(0,3) = 0;
uniform float dalton_intensity : hint_range(0.0,1.0) = 1.0;

// ===== ALTO CONTRASTE =====
uniform bool high_contrast = false;
uniform float contrast : hint_range(0.5, 2.0) = 1.4;
uniform float saturation : hint_range(0.0, 2.0) = 1.2;
uniform float brightness : hint_range(-0.5, 0.5) = 0.0;

void fragment()
{
    vec4 color = texture(screen_texture, SCREEN_UV);
    vec3 rgb = color.rgb;

    // =========================
    // 1. DALTONISMO
    // =========================
    vec3 d = rgb;

    if (filter_mode == 1)
    {
        d.r = rgb.r * 0.152286 + rgb.g * 1.052583 + rgb.b * -0.204868;
        d.g = rgb.r * 0.114503 + rgb.g * 0.786281 + rgb.b * 0.099216;
        d.b = rgb.r * -0.003882 + rgb.g * -0.048116 + rgb.b * 1.051998;
    }
    else if (filter_mode == 2)
    {
        d.r = rgb.r * 0.367322 + rgb.g * 0.860646 + rgb.b * -0.227968;
        d.g = rgb.r * 0.280085 + rgb.g * 0.672501 + rgb.b * 0.047413;
        d.b = rgb.r * -0.011820 + rgb.g * 0.042940 + rgb.b * 0.968881;
    }
    else if (filter_mode == 3)
    {
        d.r = rgb.r * 1.255528 + rgb.g * -0.076749 + rgb.b * -0.178779;
        d.g = rgb.r * -0.078411 + rgb.g * 0.930809 + rgb.b * 0.147602;
        d.b = rgb.r * 0.004733 + rgb.g * 0.691367 + rgb.b * 0.303900;
    }

    rgb = mix(rgb, d, dalton_intensity);

    // =========================
    // 2. ALTO CONTRASTE
    // =========================
    if (high_contrast)
    {
        rgb += brightness;
        rgb = (rgb - 0.5) * contrast + 0.5;

        float gray = dot(rgb, vec3(0.299, 0.587, 0.114));
        rgb = mix(vec3(gray), rgb, saturation);
    }

    rgb = clamp(rgb, 0.0, 1.0);

    COLOR = vec4(rgb, color.a);
}