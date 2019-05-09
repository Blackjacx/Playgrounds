//: Playground - noun: a place where people can play

import UIKit

extension UIBezierPath {

    /// Create UIBezierPath for regular polygon with rounded corners
    ///
    /// - parameter rect:            The CGRect of the square in which the path should be created.
    /// - parameter sides:           How many sides to the polygon (e.g. 6=hexagon; 8=octagon, etc.).
    /// - parameter lineWidth:       The width of the stroke around the polygon.
    ///                              The polygon will be inset such that the stroke stays within the above square. Default value 1.
    /// - parameter cornerRadius:    The radius to be applied when rounding the corners. Default value 0.

    convenience init(polygonIn rect: CGRect, sides: Int, lineWidth: CGFloat = 1, cornerRadius: CGFloat = 0) {
        self.init()

        let theta = 2 * CGFloat.pi / CGFloat(sides)                        // how much to turn at every corner
        let offset = cornerRadius * tan(theta / 2)                  // offset from which to start rounding corners
        let squareWidth = min(rect.size.width, rect.size.height)    // width of the square

        // calculate the length of the sides of the polygon

        var length = squareWidth - lineWidth
        if sides % 4 != 0 {                                         // if not dealing with polygon which will be square with all sides ...
            length = (length * cos(theta / 2) + offset / 2)           // ... offset it inside a circle inside the square
        }
        let sideLength = length * tan(theta / 2)

        // start drawing at `point` in lower right corner, but center it

        var point = CGPoint(x: rect.minX + rect.width / 2 + sideLength / 2 - offset,
                            y: rect.minY + rect.height / 2 + length / 2)
        var angle = CGFloat.pi
        move(to: point)

        // draw the sides and rounded corners of the polygon

        for _ in 0 ..< sides {
            point = CGPoint(x: point.x + (sideLength - offset * 2) * cos(angle),
                            y: point.y + (sideLength - offset * 2) * sin(angle))
            addLine(to: point)

            let center = CGPoint(x: point.x + cornerRadius * cos(angle + .pi / 2), y: point.y + cornerRadius * sin(angle + .pi / 2))
            addArc(withCenter: center,
                   radius: cornerRadius,
                   startAngle: angle - .pi / 2,
                   endAngle: angle + theta - .pi / 2,
                   clockwise: true)

            point = currentPoint
            angle += theta
        }

        close()

        self.lineWidth = lineWidth           // in case we're going to use CoreGraphics to stroke path, rather than CAShapeLayer
        lineJoinStyle = .round
    }
}

extension UIImage {
    private static var cache: [CGFloat:UIImage] = [:]

    /**
     * Computes the hexagonal thumb icon for a given scale.
     * The smallest size is baseSize pt. The largest size is 2*baseSize pt.
     * The image is cached for efficiency.
     * - parameter scale: The scale factor which must be >0. If it is not, it will be clamped 0.
     * - parameter baseSize: This is the minimum size for the scale value of 0.0.
     * - returns: The image scaled using the scale parameter.
     */
    public static func hexagonalImage(forBaseSize baseSize: CGFloat, scaledTo scale: Float) -> UIImage? {
        let clampedValue = CGFloat(max(scale, 0.0))
        let scale = 1.0 + clampedValue
        let size = round(baseSize * scale)
        let drawColor = UIColor.red

        if let cachedImage = cache[size] {
            return cachedImage
        }

        let bounds: CGRect = CGRect(origin: CGPoint.zero, size: CGSize(width: size, height: size))
        let lineWidth: CGFloat = 1.0 / UIScreen.main.scale
        let hexagonPath = UIBezierPath(polygonIn: bounds, sides: 6, lineWidth: lineWidth, cornerRadius: size / 12.0)
        var image: UIImage? = nil

        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)

//        let ctx = UIGraphicsGetCurrentContext()
//        ctx?.addPath(hexagonPath.cgPath)
//        ctx?.setStrokeColor(UIColor.red.cgColor)
//        ctx?.setFillColor(UIColor.red.cgColor)
//        ctx?.fillPath()

        drawColor.setStroke()
        drawColor.setFill()

        hexagonPath.lineWidth = 10
        hexagonPath.lineCapStyle = .round
        hexagonPath.lineJoinStyle = .round
        hexagonPath.fill()

        image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        if let image = image {
            cache[size] = image
        }
        return image
    }
}

let image = UIImage.hexagonalImage(forBaseSize: 24, scaledTo: 1.5)




