// Arasaka-Corp Subtle Full-Window CRT + HUD Shader for Ghostty
// Colors matched to ~/.config/omarchy/themes/arasaka-corp/colors.toml

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = fragCoord / iResolution.xy;

    // 2. Subtle chromatic aberration / phosphor fringe (restrained for crisp text)
    float chroma = 0.00065;
    vec4 center = texture(iChannel0, uv);
    float r = texture(iChannel0, vec2(uv.x + chroma, uv.y)).r;
    float b = texture(iChannel0, vec2(uv.x - chroma, uv.y)).b;
    vec3 color = vec3(mix(center.r, r, 0.35), center.g, mix(center.b, b, 0.35));

    // 3. Subtle CRT scanlines + faint vertical aperture grille
    float scanline = 1.0 - 0.055 * (0.5 + 0.5 * sin(uv.y * iResolution.y * 3.14159));
    float grille = 1.0 - 0.022 * (0.5 + 0.5 * sin(uv.x * iResolution.x * 2.1));
    color *= scanline * grille;

    // 4. Very faint animated CRT refresh sweep
    float sweep = 0.015 * smoothstep(0.0, 0.12, 0.12 - abs(fract(uv.y - iTime * 0.08) - 0.5));
    color += vec3(0.984, 0.188, 0.282) * sweep;

    // 5. Soft crimson edge vignette
    vec2 centered = uv - 0.5;
    float dist = dot(centered, centered);
    vec3 vignetteTint = vec3(0.72, 0.11, 0.14); // #B81D24
    float edgeMask = smoothstep(0.16, 0.70, dist);
    color = mix(color, color * 0.84 + vignetteTint * 0.06, edgeMask * 0.6);

    // 6. Cyber-HUD corner brackets
    vec2 px = fragCoord;
    vec2 res = iResolution.xy;
    float pad = 10.0;
    float len = 20.0;
    float thick = 1.5;

    float bracket = 0.0;
    if (px.x >= pad && px.x <= pad + len && px.y <= res.y - pad && px.y >= res.y - pad - thick) bracket = 1.0;
    if (px.x >= pad && px.x <= pad + thick && px.y <= res.y - pad && px.y >= res.y - pad - len) bracket = 1.0;
    if (px.x <= res.x - pad && px.x >= res.x - pad - len && px.y <= res.y - pad && px.y >= res.y - pad - thick) bracket = 1.0;
    if (px.x <= res.x - pad && px.x >= res.x - pad - thick && px.y <= res.y - pad && px.y >= res.y - pad - len) bracket = 1.0;
    if (px.x >= pad && px.x <= pad + len && px.y >= pad && px.y <= pad + thick) bracket = 1.0;
    if (px.x >= pad && px.x <= pad + thick && px.y >= pad && px.y <= pad + len) bracket = 1.0;
    if (px.x <= res.x - pad && px.x >= res.x - pad - len && px.y >= pad && px.y <= pad + thick) bracket = 1.0;
    if (px.x <= res.x - pad && px.x >= res.x - pad - thick && px.y >= pad && px.y <= pad + len) bracket = 1.0;

    float pulse = 0.78 + 0.22 * sin(iTime * 1.6);
    vec3 hudRed = vec3(0.984, 0.188, 0.282); // #FB3048
    color = mix(color, hudRed, bracket * 0.40 * pulse);

    float outAlpha = max(center.a, bracket * 0.40 * pulse);
    fragColor = vec4(color, outAlpha);
}
