// A shader for Ghostty to create a subtle 80s/90s TV static/grain effect.
// It aims for an aesthetically pleasing, non-intense retro look.

// Simple pseudo-random number generator (hash function)
float random(vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898,78.233))) * 43758.5453123);
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    // Get the UV coordinates (from 0.0 to 1.0 across the window)
    vec2 uv = fragCoord.xy / iResolution.xy;

    // Sample the original terminal color from the input texture (iChannel0)
    vec4 terminal_color = texture(iChannel0, uv);

    // --- 80s/90s TV Static/Grain Effect ---

    // 1. Generate fine-grained noise
    //    - `fragCoord * 1000.0`: Multiplies the coordinate to create very small, pixel-level noise.
    //    - `iTime * 5.0`: Adds time to the seed, making the noise flicker subtly over time.
    float noise_val = random(fragCoord * 1000.0 + iTime * 5.0);

    // Scale the noise to be between -0.5 and 0.5, then apply a small intensity.
    // This creates noise that slightly brightens or darkens the pixel.
    float noise_intensity = 0.03; // Adjust this: lower for less static, higher for more.
    float final_noise = (noise_val * 2.0 - 1.0) * noise_intensity;

    // 2. Apply noise to the terminal color
    vec3 final_rgb = terminal_color.rgb + final_noise;

    // 3. Subtle desaturation for a retro feel (optional, adjust mix amount)
    //    Converts the color slightly towards grayscale.
    float luma = dot(final_rgb, vec3(0.299, 0.587, 0.114)); // Calculate luminance
    final_rgb = mix(final_rgb, vec3(luma), 0.05); // Blend 5% towards grayscale

    // 4. Very subtle color tint (optional, adjust tint vector)
    //    Can simulate old CRT phosphors or slight color drift.
    //    This example adds a very slight warm (reddish/yellowish) tint.
    vec3 tint = vec3(1.0, 0.99, 0.98); // Adjust these values for different tints
    final_rgb *= tint;

    // 5. Clamp to ensure colors stay within valid range [0, 1]
    final_rgb = clamp(final_rgb, 0.0, 1.0);

    // Output the final mixed color, preserving the original alpha channel.
    fragColor = vec4(final_rgb, terminal_color.a);
}
