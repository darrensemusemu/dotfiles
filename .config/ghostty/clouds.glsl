// A shader for Ghostty aiming for an abstract landscape
// with a blocky/pixelated feel, reminiscent of retro ASCII art.
// It's designed to be subtle, aesthetically pleasing, and non-distracting.



// Improved noise function for better terrain generation
float noise(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453);
}

// Fractal noise for more realistic terrain
float fbm(vec2 p) {
    float value = 0.0;
    float amplitude = 0.5;
    float frequency = 1.0;

    for (int i = 0; i < 6; i++) {
        value += amplitude * noise(p * frequency);
        amplitude *= 0.5;
        frequency *= 2.0;
    }
    return value;
}

// Smooth minimum function for blending shapes
float smin(float a, float b, float k) {
    float h = clamp(0.5 + 0.5 * (b - a) / k, 0.0, 1.0);
    return mix(b, a, h) - k * h * (1.0 - h);
}

// Distance function for a winding path
float pathSDF(vec2 p, float time) {
    // Create a sinuous path that winds across the screen
    float pathY = 0.85 + 0.05 * sin(p.x * 8.0 + time * 0.3) + 0.03 * sin(p.x * 16.0 + time * 0.7);
    float pathWidth = 0.008 + 0.004 * sin(p.x * 12.0 + time * 0.5);
    return abs(p.y - pathY) - pathWidth;
}

void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
    vec2 uv = fragCoord.xy / iResolution.xy;
    vec4 terminal_color = texture(iChannel0, uv);

    // Only apply effect to bottom 15% of screen
    float screenMask = smoothstep(0.82, 0.88, uv.y);
    if (screenMask < 0.001) {
        fragColor = terminal_color;
        return;
    }

    // Transform coordinates for landscape
    vec2 p = uv;
    p.y = (p.y - 0.85) * 6.0; // Focus on bottom portion and stretch vertically

    // Animate the scene
    float time = iTime * 0.4;
    p.x += time * 0.02; // Slow horizontal drift

    // Generate multiple mountain layers with parallax
    float mountain1 = fbm(p * vec2(3.0, 8.0) + vec2(time * 0.1, 0.0)) * 0.6;
    float mountain2 = fbm(p * vec2(2.0, 6.0) + vec2(time * 0.05, 0.3)) * 0.4;
    float mountain3 = fbm(p * vec2(4.0, 10.0) + vec2(time * 0.15, 0.6)) * 0.3;

    // Combine mountains for depth
    float mountains = mountain1;
    mountains = smin(mountains, mountain2 + 0.2, 0.1);
    mountains = smin(mountains, mountain3 + 0.4, 0.15);

    // Create the mountain silhouette
    float mountainMask = smoothstep(0.1, 0.3, mountains - p.y + 0.5);

    // Winding path
    float pathDist = pathSDF(uv, iTime);
    float pathMask = 1.0 - smoothstep(0.0, 0.003, pathDist);

    // Secondary path for interest
    float path2Y = 0.9 + 0.02 * sin(uv.x * 12.0 + iTime * 0.4);
    float path2Dist = abs(uv.y - path2Y) - 0.004;
    float path2Mask = 1.0 - smoothstep(0.0, 0.002, path2Dist);

    // Color palette - warm, inviting colors
    vec3 skyColor = mix(
        vec3(0.3, 0.4, 0.7),      // Deep blue
        vec3(0.8, 0.6, 0.4),      // Warm orange
        smoothstep(0.0, 1.0, p.x * 0.5 + 0.5 + sin(time * 0.2) * 0.3)
    );

    vec3 mountainColor = mix(
        vec3(0.2, 0.3, 0.5),      // Cool mountain base
        vec3(0.4, 0.5, 0.3),      // Warmer peaks
        fbm(p * 8.0) * 0.7 + 0.3
    );

    vec3 pathColor = vec3(0.9, 0.8, 0.6);     // Warm path
    vec3 path2Color = vec3(0.7, 0.6, 0.5);    // Subtle second path

    // Add atmospheric perspective
    float depth = smoothstep(0.0, 1.0, p.y + 0.3);
    mountainColor = mix(mountainColor, skyColor, depth * 0.4);

    // Combine elements
    vec3 landscape = skyColor;
    landscape = mix(landscape, mountainColor, mountainMask);
    landscape = mix(landscape, pathColor, pathMask);
    landscape = mix(landscape, path2Color, path2Mask * 0.7);

    // Add subtle lighting effects
    float lighting = 0.8 + 0.2 * sin(p.x * 6.0 + time * 0.5);
    landscape *= lighting;

    // Add a bit of mist/atmosphere at the base
    float mist = fbm(p * vec2(8.0, 2.0) + vec2(time * 0.3, 0.0)) * 0.3;
    mist *= smoothstep(0.0, 0.4, p.y + 0.8);
    landscape = mix(landscape, vec3(0.9, 0.9, 1.0), mist * 0.2);

    // Blend with terminal content
    float blendAmount = 0.35 * screenMask; // Stronger effect, but only where masked
    vec3 final_rgb = mix(terminal_color.rgb, landscape, blendAmount);

    // Add a subtle vignette to the landscape area
    float vignette = 1.0 - length(p - vec2(0.0, -0.2)) * 0.3;
    final_rgb = mix(final_rgb, final_rgb * vignette, screenMask * 0.3);

    fragColor = vec4(final_rgb, terminal_color.a);
}
