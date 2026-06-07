import AppKit
import Foundation

let size = 1024
let canvas = NSRect(x: 0, y: 0, width: size, height: size)
let outputURL = URL(fileURLWithPath: "PaperAccept/Assets.xcassets/AppIcon.appiconset/AppIcon.png")

func color(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat, _ alpha: CGFloat = 1) -> NSColor {
    NSColor(calibratedRed: red, green: green, blue: blue, alpha: alpha)
}

func drawText(_ text: String, in rect: NSRect, size: CGFloat, weight: NSFont.Weight, color textColor: NSColor) {
    let paragraph = NSMutableParagraphStyle()
    paragraph.alignment = .center
    paragraph.lineBreakMode = .byClipping
    let attributes: [NSAttributedString.Key: Any] = [
        .font: NSFont.systemFont(ofSize: size, weight: weight),
        .foregroundColor: textColor,
        .paragraphStyle: paragraph,
        .kern: -1.0
    ]
    text.draw(in: rect, withAttributes: attributes)
}

func rounded(_ rect: NSRect, radius: CGFloat) -> NSBezierPath {
    NSBezierPath(roundedRect: rect, xRadius: radius, yRadius: radius)
}

let bitmap = NSBitmapImageRep(
    bitmapDataPlanes: nil,
    pixelsWide: size,
    pixelsHigh: size,
    bitsPerSample: 8,
    samplesPerPixel: 4,
    hasAlpha: true,
    isPlanar: false,
    colorSpaceName: .calibratedRGB,
    bytesPerRow: 0,
    bitsPerPixel: 0
)!
bitmap.size = NSSize(width: size, height: size)
NSGraphicsContext.saveGraphicsState()
NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: bitmap)

NSGraphicsContext.current?.imageInterpolation = .high
NSGradient(
    colors: [
        color(0.96, 0.98, 0.91),
        color(0.72, 0.92, 0.82),
        color(0.99, 0.73, 0.40)
    ]
)?.draw(in: canvas, angle: -32)

color(1.0, 0.82, 0.28, 0.38).setFill()
NSBezierPath(ovalIn: NSRect(x: 620, y: 630, width: 340, height: 340)).fill()
color(0.18, 0.70, 0.56, 0.28).setFill()
NSBezierPath(ovalIn: NSRect(x: -80, y: 120, width: 390, height: 390)).fill()

let bodyRect = NSRect(x: 260, y: 180, width: 504, height: 472)
color(1, 1, 1, 0.96).setFill()
rounded(bodyRect, radius: 148).fill()

color(0.08, 0.08, 0.09, 0.08).setFill()
rounded(NSRect(x: 282, y: 156, width: 460, height: 58), radius: 29).fill()

let leftEar = NSBezierPath()
leftEar.move(to: NSPoint(x: 360, y: 602))
leftEar.line(to: NSPoint(x: 420, y: 742))
leftEar.line(to: NSPoint(x: 480, y: 610))
leftEar.close()
color(1, 1, 1, 0.96).setFill()
leftEar.fill()

let rightEar = NSBezierPath()
rightEar.move(to: NSPoint(x: 544, y: 610))
rightEar.line(to: NSPoint(x: 604, y: 742))
rightEar.line(to: NSPoint(x: 664, y: 602))
rightEar.close()
rightEar.fill()

color(0.96, 0.70, 0.22, 0.42).setFill()
NSBezierPath(ovalIn: NSRect(x: 384, y: 584, width: 56, height: 66)).fill()
NSBezierPath(ovalIn: NSRect(x: 584, y: 584, width: 56, height: 66)).fill()

color(0.08, 0.08, 0.09).setFill()
NSBezierPath(ovalIn: NSRect(x: 380, y: 444, width: 58, height: 70)).fill()
NSBezierPath(ovalIn: NSRect(x: 586, y: 444, width: 58, height: 70)).fill()

color(1, 1, 1, 0.92).setFill()
NSBezierPath(ovalIn: NSRect(x: 398, y: 486, width: 18, height: 22)).fill()
NSBezierPath(ovalIn: NSRect(x: 604, y: 486, width: 18, height: 22)).fill()

color(0.93, 0.30, 0.42, 0.25).setFill()
NSBezierPath(ovalIn: NSRect(x: 324, y: 388, width: 96, height: 44)).fill()
NSBezierPath(ovalIn: NSRect(x: 604, y: 388, width: 96, height: 44)).fill()

let mouth = NSBezierPath()
mouth.move(to: NSPoint(x: 484, y: 404))
mouth.curve(to: NSPoint(x: 512, y: 386), controlPoint1: NSPoint(x: 494, y: 386), controlPoint2: NSPoint(x: 504, y: 382))
mouth.curve(to: NSPoint(x: 540, y: 404), controlPoint1: NSPoint(x: 520, y: 382), controlPoint2: NSPoint(x: 532, y: 386))
mouth.lineWidth = 8
color(0.08, 0.08, 0.09, 0.72).setStroke()
mouth.stroke()

let badge = rounded(NSRect(x: 190, y: 690, width: 644, height: 174), radius: 58)
color(0.08, 0.08, 0.09).setFill()
badge.fill()
drawText("ACCEPT +1", in: NSRect(x: 208, y: 722, width: 608, height: 98), size: 78, weight: .black, color: .white)

let paper = rounded(NSRect(x: 318, y: 250, width: 388, height: 116), radius: 34)
color(0.18, 0.70, 0.56).setFill()
paper.fill()
drawText("PAPER", in: NSRect(x: 338, y: 280, width: 348, height: 58), size: 42, weight: .black, color: .white)

NSGraphicsContext.restoreGraphicsState()

guard let pngData = bitmap.representation(using: .png, properties: [:]) else {
    fatalError("Failed to render app icon")
}

try FileManager.default.createDirectory(at: outputURL.deletingLastPathComponent(), withIntermediateDirectories: true)
try pngData.write(to: outputURL)
print(outputURL.path)
