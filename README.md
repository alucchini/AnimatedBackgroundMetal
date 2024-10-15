# AnimatedBackground

Create a stunning animated background using Metal and SwiftUI. This project demonstrates how to build a dynamic, grainy gradient background that smoothly evolves over time, giving your app a visually engaging backdrop.

## Features

- 🎨 **Smooth Gradient Animation**: Uses Hermite interpolation for seamless transitions between colors.
- 🌟 **Grainy Texture Effect**: Adds a subtle noise to the background, giving it a unique texture.
- 🚀 **Customizable Colors**: Easily modify the gradient colors to match your app’s theme.
- 💡 **Optimized for iOS 17+**: Leverages the power of SwiftUI and Metal for smooth animations.

## Preview

![Animated Background Preview](AnimatedBgScreenshot.mp4)

## Requirements

- Xcode 15+
- Swift 5.9+
- iOS 17+

## Getting Started

Clone the repository and open the project in Xcode:

```bash
git clone https://github.com/alucchini/AnimatedBackground.git
cd AnimatedBackground
```

## Usage

The project includes a `ContentView` with an animated background that updates smoothly over time using `TimelineView` and a custom Metal shader.

### Code Breakdown

#### `ContentView` Implementation

This is the main view where the background animation happens:

```swift
struct ContentView: View {
    @State private var startTime = Date.now

    var body: some View {
        TimelineView(.animation) { timeline in
            let elapsedTime = startTime.distance(to: Date.now)
            Rectangle()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .foregroundStyle(.grainGradient(time: elapsedTime * 3))
                .opacity(0.6)
                .background(.black)
                .ignoresSafeArea()
        }
    }
}
```

- `@State private var startTime = Date.now`: This state variable captures the time when the view appears. It is used to calculate the elapsed time for the animation.
- `TimelineView(.animation)`: This view updates its contents based on the provided timeline, allowing the background to update smoothly in sync with animation frames.
- `let elapsedTime = startTime.distance(to: Date.now)`: Computes the elapsed time since the start, driving the animation.
- `Rectangle().frame(maxWidth: .infinity, maxHeight: .infinity)`: Creates a rectangle that covers the entire screen.
- `.foregroundStyle(.grainGradient(time: elapsedTime * 3))`: Uses the custom gradient function to apply the animated gradient as the foreground style.
- `.opacity(0.6)`: Makes the rectangle semi-transparent, allowing the background to show through.
- `.background(.black).ignoresSafeArea()`: Sets a black background behind the gradient and ensures it covers the entire screen area.

#### Color Initialization with Hex Codes

To make defining colors easier, this extension allows initializing colors using hex codes:

```swift
extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#")

        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)

        let red = Double((rgb >> 16) & 0xFF) / 255.0
        let green = Double((rgb >> 8) & 0xFF) / 255.0
        let blue = Double(rgb & 0xFF) / 255.0

        self.init(red: red, green: green, blue: blue)
    }
}
```

- `let scanner = Scanner(string: hex)`: Reads the hex string for the color.
- `scanner.scanHexInt64(&rgb)`: Converts the hex code into a 64-bit integer representing RGB values.
- `let red`, `let green`, `let blue`: Extracts and normalizes the red, green, and blue values from the RGB integer.
- `self.init(red: red, green: green, blue: blue)`: Initializes a SwiftUI `Color` with the extracted RGB values.

#### Custom Gradient Colors

Define the gradient colors that will be used for the animated background:

```swift
private let tl = Color(hex: "#41FF00") // Top-left color
private let tc = Color(hex: "#FF97E8") // Top-center color
private let tr = Color(hex: "#FFF200") // Top-right color

private let ml = Color(hex: "#FF97E8") // Middle-left color
private let mc = Color(hex: "#FFF200") // Middle-center color
private let mr = Color(hex: "#41FF00") // Middle-right color

private let bl = Color(hex: "#FFF200") // Bottom-left color
private let bc = Color(hex: "#41FF00") // Bottom-center color
private let br = Color(hex: "#FF97E8") // Bottom-right color
```

- These variables define the colors for different regions of the gradient.
- Each color corresponds to a different part of the grid, enabling a smooth transition between multiple colors.

#### Metal Shader for Grainy Gradient

This Metal shader handles the gradient's smooth transitions and grainy effect:

```cpp
#include <metal_stdlib>
#include <SwiftUI/SwiftUI.h>

using namespace metal;

float h00(float x) { return 2.0 * x * x * x - 3.0 * x * x + 1.0; }
float h10(float x) { return x * x * x - 2.0 * x * x + x; }
float h01(float x) { return 3.0 * x * x - 2.0 * x * x * x; }
float h11(float x) { return x * x * x - x * x; }

float hermite(float p0, float p1, float m0, float m1, float x) {
    return p0 * h00(x) + m0 * h10(x) + p1 * h01(x) + m1 * h11(x);
}
```

- **Hermite Interpolation Functions** (`h00`, `h10`, `h01`, `h11`): These functions define the basis functions for Hermite interpolation, creating smooth transitions between values.
- **`hermite` function**: Uses the basis functions to interpolate smoothly between control points, ensuring fluid transitions across the gradient.

#### Grainy Texture and Color Interpolation

```cpp
half4 gridInterpolation(float2 coords, device const half4 *colors, float4 gridRange, int2 gridSize, int lastIndex, float time) {

    float a = sin(time * 1.0) * 0.5 + 0.5;
    float b = sin(time * 1.5) * 0.5 + 0.5;
    float c = sin(time * 2.0) * 0.5 + 0.5;
    float d = sin(time * 2.5) * 0.5 + 0.5;

    float y0 = mix(a, b, coords.x);
    float y1 = mix(c, d, coords.x);
    float x0 = mix(a, c, coords.y);
    float x1 = mix(b, d, coords.y);

    coords.x = hermite(0.0, 1.0, 2.0 * x0, 2.0 * x1, coords.x);
    coords.y = hermite(0.0, 1.0, 2.0 * y0, 2.0 * y1, coords.y);
}
```

- **Sinusoidal Modulation**: Uses sine functions to create smooth oscillations over time, contributing to the dynamic appearance of the background.
- **`mix` functions**: Interpolates between different points to ensure smooth transitions as time progresses.
- **`hermite`**: Refines the transitions between grid points, ensuring a smooth gradient flow.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
