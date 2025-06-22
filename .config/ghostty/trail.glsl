// Quantization function to create a blocky, ASCII-like effect.
// It limits the precision of a value to a certain number of steps.
float quantize(float value, float steps) {
    if (steps == 0.0) return value;
    return floor(value * steps) / steps;
}

// Generates a pseudo-random value for a given 2D position, creating a blocky noise
// pattern that mimics the grid of ASCII characters.
float blockNoise(vec2 p) {
    // Using floor on the position creates large blocks of the same value.
    vec2 blockP = floor(p * 20.0);
    return fract(sin(dot(blockP, vec2(127.1, 311.7))) * 43758.5453);
}

// Generates a single mountain. The shape is primarily triangular but with noise
// added to the slope to create a more rugged, retro-game appearance.
float asciiMountain(vec2 p, float seed, float height, float width) {
    // Determine a random horizontal position for the mountain's peak.
    float center = fract(seed * 43.758) * 0.8 + 0.1;
    // Determine a random height for the peak.
    float peakHeight = height * (0.7 + 0.3 * fract(seed * 23.14));

    // Calculate the distance from the center to create a triangular shape.
    float dist = abs(p.x - center) / width;
    float mountain = max(0.0, peakHeight * (1.0 - dist));

    // Add noise to the mountain silhouette to make it look less perfect and more "rendered".
    mountain -= blockNoise(p * vec2(1.0/width, 1.0/height) * 2.0) * 0.05;

    // Quantize the final value to enhance the blocky aesthetic.
    return quantize(max(0.0, mountain), 16.0);
}

// Generates a simple tree shape for the foreground.
float asciiTree(vec2 p, float treeX, float size) {
    // Center the tree at the given x-position, near the bottom of the screen.
    vec2 treePos = vec2(treeX, 0.1);
    vec2 toTree = p - treePos;

    // The trunk is a simple, thin rectangle.
    float trunk = 0.0;
    if (abs(toTree.x) < 0.005 * size && toTree.y < 0.0 && toTree.y > -0.02 * size) {
        trunk = 1.0;
    }

    // The crown is a blocky triangular shape on top of the trunk.
    float crown = 0.0;
    float crownBase = 0.0;
    float crownTop = 0.05 * size;
    float crownWidth = 0.03 * size;

    if (toTree.y > crownBase && toTree.y < crownTop) {
        float progress = (toTree.y - crownBase) / (crownTop - crownBase);
        float currentWidth = crownWidth * (1.0 - progress);
        if (abs(toTree.x) < currentWidth) {
            crown = 1.0;
        }
    }

    // Return 1.0 if the pixel is part of either the trunk or the crown.
    return max(trunk, crown);
}

// Generates ASCII-style clouds made of several blocky circles.
float asciiCloud(vec2 p, float cloudX, float cloudY, float size, float time) {
    // Animate position from left to right and loop it, covering a range
    // wider than the screen to allow clouds to fully enter and exit.
    float xPos = -0.5 + fract(time + cloudX * 0.3) * 2.0;

    // Quantize the input coordinates to make the entire cloud move in a blocky way.
    vec2 cloudPos = vec2(xPos, cloudY);
    vec2 toCloud = p - cloudPos;
    toCloud = (floor(toCloud * 64.0) / 64.0) / size;

    // Build the cloud from several overlapping, differently sized circles.
    float cloud = 0.0;
    for (int i = 0; i < 5; i++) {
        float fi = float(i);
        vec2 offset = vec2(fi * 0.3 - 0.6, sin(fi * 2.0) * 0.1);
        float radius = 0.3 + 0.2 * sin(fi * 3.14);
        // The distance check creates the circular shape.
        if (length(toCloud - offset) < radius) {
            cloud = 1.0;
        }
    }
    return cloud;
}

// Generates a helicopter shape that flies from right to left.
float asciiHelicopter(vec2 p, float yPos, float size, float time) {
    // Animate position from right to left (1.5 to -0.5) and loop it.
    float xPos = 1.5 - fract(time * 0.1) * 2.0;
    vec2 heliPos = vec2(xPos, yPos);

    // Normalize coordinates relative to the helicopter's center and scale.
    vec2 toHeli = (p - heliPos) / size;

    // Cockpit (a rounded rectangle/capsule)
    float cockpit = 0.0;
    if (abs(toHeli.y) < 0.05 && abs(toHeli.x) < 0.2) {
        cockpit = 1.0;
    }
    if (length(toHeli - vec2(-0.2, 0.0)) < 0.05 || length(toHeli - vec2(0.2, 0.0)) < 0.05) {
        cockpit = 1.0;
    }

    // Tail boom (a thin rectangle)
    float tail = 0.0;
    if (toHeli.y > -0.015 && toHeli.y < 0.015 && toHeli.x > 0.2 && toHeli.x < 0.5) {
        tail = 1.0;
    }

    // Tail rotor (a small vertical line)
    float tailRotor = 0.0;
    if (abs(toHeli.x - 0.5) < 0.01 && abs(toHeli.y - 0.02) < 0.03) {
        tailRotor = 1.0;
    }

    // Main rotor (a thin line that "spins" by changing length based on time)
    float rotor = 0.0;
    float rotorLength = 0.4 + 0.1 * sin(time * 100.0); // Fast sin wave simulates spinning blur
    if (abs(toHeli.y - 0.07) < 0.01 && abs(toHeli.x) < rotorLength) {
        rotor = 1.0;
    }

    // Combine all parts.
    return max(cockpit, max(tail, max(tailRotor, rotor)));
}

void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
    vec2 uv = fragCoord.xy / iResolution.xy;
    vec4 terminal_color = texture(iChannel0, uv);

    float time = iTime * 0.02; // Slow animation speed for a relaxed feel.

    // --- SCENE COMPOSITION ---
    // The scene is built from back to front, starting with a black sky.
    vec3 landscape = vec3(0.0); // 0.0 = black

    // 1. Clouds (Farthest back)
    // Clouds are bright white and move slowly across the sky.
    float clouds = 0.0;
    // Two smaller clouds instead of three large ones.
    clouds = max(clouds, asciiCloud(uv, 0.2, 0.85, 0.10, time * 0.3)); // Reduced size from 0.15
    clouds = max(clouds, asciiCloud(uv, 0.7, 0.9, 0.12, time * 0.1)); // Reduced size from 0.15
    // clouds = max(clouds, asciiCloud(uv, 0.5, 0.75, 0.25, time * 0.7)); // This cloud is removed.
    // clouds = max(clouds, asciiCloud(uv, 0.5, 0.75, 0.25, time * 0.7));
    // Clouds are solid white (1.0) to contrast sharply with the dark sky.
    landscape = mix(landscape, vec3(0.2), clouds);

    // 2. Helicopter
    // float helicopter = asciiHelicopter(uv, 0.6, 0.1, iTime);
    // // Helicopter is dark, like a silhouette
    // landscape = mix(landscape, vec3(0.1), helicopter);

    // 3. Mountains (Layered in middle ground)
    // Mountains are created in layers, with distant ones being darker.
    // We use step() to create hard edges from the mountain function's output.
    float mtn_far = asciiMountain(uv, 1.0, 0.35, 0.6);
    float mtn_mid1 = asciiMountain(uv, 2.0, 0.25, 0.3);
    float mtn_mid2 = asciiMountain(uv, 3.0, 0.3, 0.4);
    float mtn_near = asciiMountain(uv, 4.0, 0.15, 0.2);

    // Mix in each mountain layer with a progressively lighter shade of gray.
    landscape = mix(landscape, vec3(0.3), step(uv.y, mtn_far));   // Dark gray
    landscape = mix(landscape, vec3(0.5), step(uv.y, mtn_mid1));  // Medium gray
    landscape = mix(landscape, vec3(0.55), step(uv.y, mtn_mid2)); // Medium gray
    landscape = mix(landscape, vec3(0.7), step(uv.y, mtn_near));  // Light gray

    // 4. Trees (Closest in foreground)
    // A line of trees is drawn at the bottom of the scene.
    float trees = 0.0;
    for (int i = 0; i < 15; i++) {
        float fi = float(i);
        // Stagger tree positions and sizes for a more natural look.
        float treeX = (fi / 14.0) * 1.2 - 0.1 + sin(fi) * 0.01;
        float treeSize = 0.8 + 0.4 * fract(sin(fi * 2.5) * 43.0);
        trees = max(trees, asciiTree(uv, treeX, treeSize));
    }
    // Trees are very dark to appear as silhouettes in the foreground.
    landscape = mix(landscape, vec3(0.1), trees);


    // --- FINAL BLENDING ---
    // Blend the generated landscape with the terminal's actual text color.
    // A lower blend amount keeps the text readable over the background art.
    float blendAmount = 0.2;
    vec3 final_rgb = mix(terminal_color.rgb, landscape, blendAmount);

    // Apply a slight contrast boost to make the blacks blacker and whites whiter.
    final_rgb = pow(final_rgb, vec3(1.1));

    fragColor = vec4(final_rgb, terminal_color.a);
}
