#version 300 es
precision highp float;

in vec2 v_texcoord;
uniform sampler2D tex;
out vec4 fragColor;

void main() {
    vec4 color = texture(tex, v_texcoord);
    vec2 texel = 1.0 / vec2(textureSize(tex, 0));

    // Restrained two-ring 16-tap phosphor bloom for Arasaka-Corp
    vec3 innerBloom = vec3(0.0);
    vec2 innerOffsets[8] = vec2[8](
        vec2(-2.0,  0.0), vec2( 2.0,  0.0),
        vec2( 0.0, -2.0), vec2( 0.0,  2.0),
        vec2(-3.0, -3.0), vec2( 3.0, -3.0),
        vec2(-3.0,  3.0), vec2( 3.0,  3.0)
    );

    vec3 outerBloom = vec3(0.0);
    vec2 outerOffsets[8] = vec2[8](
        vec2(-5.5,  0.0), vec2( 5.5,  0.0),
        vec2( 0.0, -5.5), vec2( 0.0,  5.5),
        vec2(-7.0, -7.0), vec2( 7.0, -7.0),
        vec2(-7.0,  7.0), vec2( 7.0,  7.0)
    );

    for (int i = 0; i < 8; i++) {
        vec3 s1 = texture(tex, v_texcoord + innerOffsets[i] * texel).rgb;
        float e1 = max(dot(s1, vec3(0.299, 0.587, 0.114)), s1.r * 0.70);
        innerBloom += s1 * smoothstep(0.10, 0.46, e1);

        vec3 s2 = texture(tex, v_texcoord + outerOffsets[i] * texel).rgb;
        float e2 = max(dot(s2, vec3(0.299, 0.587, 0.114)), s2.r * 0.70);
        outerBloom += s2 * smoothstep(0.10, 0.46, e2);
    }
    vec3 bloom = (innerBloom / 8.0) * 0.65 + (outerBloom / 8.0) * 0.35;

    // Warm CRT phosphor amber/crimson halo
    vec3 amberTint = vec3(1.10, 0.74, 0.32);
    color.rgb += bloom * amberTint * 0.45;

    // Subtle horizontal CRT scanlines (~8% modulation)
    float scanline = 0.96 + 0.04 * sin(gl_FragCoord.y * 3.14159265);
    color.rgb *= scanline;

    // Subtle CRT edge vignette
    vec2 uv = v_texcoord * (1.0 - v_texcoord.yx);
    float vignette = clamp(pow(uv.x * uv.y * 16.0, 0.085), 0.91, 1.0);
    color.rgb *= vignette;

    fragColor = color;
}
