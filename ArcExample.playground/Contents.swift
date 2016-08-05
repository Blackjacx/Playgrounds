//: Playground - noun: a place where people can play

import UIKit

extension CGVector {
    /* Create a vector from the given CGPoint */
    init(point: CGPoint) {
        dx = point.x
        dy = point.y
    }

    /* Add two vectors */
    func sum(vector: CGVector) -> CGVector {
        return CGVector(dx: dx + vector.dx, dy: dy + vector.dy)
    }

    /* Subtract two vectors */
    func difference(vector: CGVector) -> CGVector {
        return CGVector(dx: dx - vector.dx, dy: dy - vector.dy)
    }

    /* Multiply two vectors */
    func multiply(vector: CGVector) -> CGVector {
        return CGVector(dx: dx * vector.dx, dy: dy * vector.dy)
    }

    /* Multiply a vector by a single scalar */
    func multiply(scalar: CGFloat) -> CGVector {
        return CGVector(dx: dx * scalar, dy: dy * scalar)
    }

    /* Normalize a vector. This scales the length of the vector to 1, creating a unit vector */
    func normalize() -> CGVector {
        let len = length()
        if len == 0 {
            return CGVector.zero
        }

        let scale = 1.0 / len
        return multiply(scale)
    }

    /* Creates a vector perpendicular to `vector` */
    func makePerpendicular() -> CGVector {
        return CGVector(dx: -dy, dy: dx)
    }

    /* Calculate the angle of between two vectors */
    func angleTo(vector: CGVector) -> CGFloat {
        let dot = dotProduct(vector)
        let magnitude = length() * vector.length()
        if magnitude == 0 {
            return 0
        }

        let clampedMagnitude = max(min(Float(dot / magnitude), 1.0), -1.0)
        return CGFloat(acosf(clampedMagnitude))
    }

    /* Calculate the angle of `vector` */
    func angle() -> CGFloat {
        return atan2(dx, dy)
    }

    /* Calculate the angle of `vector` for use with a SpriteKit zRotation property */
    func angleSpriteKit() -> CGFloat {
        return fmod(CGFloat(M_PI * 2.0) - angle() + CGFloat(M_PI_2), CGFloat(M_PI * 2.0))
    }

    /* Calculate the dot product of two vectors */
    func dotProduct(vector: CGVector) -> CGFloat {
        return dx * vector.dx + dy * vector.dy
    }

    /* Calculate the magnitude (length) of a vector */
    func length() -> CGFloat {
        return hypot(dx, dy)
    }

    /* Calculate the distance between two vectors */
    func distance(vector: CGVector) -> CGFloat {
        return vector.difference(self).length()
    }

    /* Returns true if a given vector is perpendicular to this vector */
    func isPerpendicularTo(vector: CGVector) -> Bool {
        return dotProduct(vector) == 0
    }

    func asPoint() -> CGPoint {
        return CGPoint(x: dx, y: dy)
    }
}

func curvedArrow(with start: CGPoint, end: CGPoint, strokeColor: UIColor, fillColor: UIColor) -> (CGPathRef, CGPathRef) {
    let arrowHeadWidth: CGFloat = 15
    let arrowHeadLength: CGFloat = 15
    let tailPath: CGMutablePathRef = CGPathCreateMutable()
    let majorDirection = CGVector(dx: end.x - start.x, dy: end.y - start.y)
    let majorDirectionHalfSize = majorDirection.multiply(0.5).sum(CGVector(point: start))
    let majorDirectionPerpendicular = majorDirection.makePerpendicular().normalize().multiply(majorDirection.length()/5)
    let controlPointVector = majorDirectionHalfSize.sum(majorDirectionPerpendicular)
    let controlPoint = CGPoint(x:controlPointVector.dx, y: controlPointVector.dy)
    let lineEnd = CGVector(dx: controlPoint.x - end.x, dy: controlPoint.y - end.y).normalize().multiply(arrowHeadLength).sum(CGVector(point: end)).asPoint()

    CGPathMoveToPoint(tailPath, nil, start.x, start.y)
    CGPathAddQuadCurveToPoint(tailPath, nil, controlPoint.x, controlPoint.y, lineEnd.x, lineEnd.y)

    // Draw the arrow
    let arrowStart = CGVector(point: lineEnd)
    let arrowDirection = CGVector(point: controlPoint).difference(arrowStart).normalize()
    let arrowEnd = arrowStart.sum(arrowDirection)
    let length = arrowEnd.difference(arrowStart).length()
    let points = [CGPoint(x: -arrowHeadLength, y: 0), CGPoint(x: 0, y: -arrowHeadWidth/2), CGPoint(x: 0, y: arrowHeadWidth/2), CGPoint(x: -arrowHeadLength, y: 0)]
    let cosine: CGFloat = (arrowDirection.dx)/length
    let sine: CGFloat = (arrowDirection.dy)/length
    var transform = CGAffineTransformMake(cosine, sine, -sine, cosine, arrowStart.dx, arrowStart.dy)

    let headPath: CGMutablePathRef = CGPathCreateMutable()
    CGPathAddLines(headPath, &transform, points, points.count)

    return (tailPath, headPath)
}


let (tail, arrow) = curvedArrow(with: CGPoint(x: 0, y: 0), end: CGPoint(x: 300, y: 300), strokeColor: UIColor.redColor(), fillColor: UIColor.redColor())
UIBezierPath(CGPath: tail)
UIBezierPath(CGPath: arrow)



