import UIKit

var background: UIColor { UIColor(light: 0xffffff, dark: 0x000000) }
var text: UIColor { UIColor(light: 0x141923, dark: 0x959596) }

extension UIColor {

    // MARK: - Specify All Colors

    convenience init(light: UIColor, lightHigh: UIColor, dark: UIColor, darkHigh: UIColor) {

        guard #available(iOS 13, *) else {
            self.init(ciColor: light.ciColor)
            return
        }

        self.init(dynamicProvider: { (traits) in
            switch traits.userInterfaceStyle {
            case .unspecified, .light :
                switch traits.accessibilityContrast {
                case .unspecified, .normal: return light
                case .high: return lightHigh
                }
            case .dark:
                switch traits.accessibilityContrast {
                case .unspecified, .normal: return dark
                case .high: return darkHigh
                }
            }
        })
    }

    convenience init(light: Int, lightHigh: Int, dark: Int, darkHigh: Int) {

        self.init(light: UIColor(light),
                  lightHigh: UIColor(lightHigh),
                  dark: UIColor(dark),
                  darkHigh: UIColor(darkHigh))
    }

    // MARK: - Specify Light/Dark only

    convenience init(light: UIColor, dark: UIColor) {
        self.init(light: light, lightHigh: light, dark: dark,darkHigh: dark)
    }

    convenience init(light: Int, dark: Int) {
        self.init(light: UIColor(light), dark: UIColor(dark))
    }

    // MARK: - Helper

    convenience init(red: UInt8, green: UInt8, blue: UInt8) {
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }

    // MARK: - Hex

    convenience init(_ hex: Int) {
        self.init(red: UInt8((hex >> 16) & 0xFF), green: UInt8((hex >> 8) & 0xFF), blue: UInt8(hex & 0xFF))
    }

    var hexValue: Int {
        let col = CIColor(color: self)
        let rgb: Int = Int(col.red * 255) << 16 | Int(col.green * 255) << 8 | Int(col.blue * 255) << 0
        return rgb
    }

    var hexString: String {
        let col = CIColor(color: self)
        return String(format: "#%02lX%02lX%02lX", Int(col.red * 255), Int(col.green * 255), Int(col.blue * 255))
    }
}

/// `false` use of dynamic provider
background == background

/// `true` same parameters
UIColor(red: 0, green: 0, blue: 0, alpha: 0) == UIColor(red: 0, green: 0, blue: 0, alpha: 0)

/// `false` different pointers
UIColor(red: 0, green: 0, blue: 0, alpha: 0) === UIColor(red: 0, green: 0, blue: 0, alpha: 0)

/// `true` same parameters
UIColor.white == UIColor.white

/// `true` same pointer
UIColor.white === UIColor.white


// MARK: - Contrast [WIP]

extension UIColor {

    static func contrast(between color1: UIColor, and color2: UIColor) -> CGFloat {
        // https://www.w3.org/TR/WCAG20-TECHS/G18.html#G18-tests

        let luminance1 = color1.luminance()
        let luminance2 = color2.luminance()

        let luminanceDarker = min(luminance1, luminance2)
        let luminanceLighter = max(luminance1, luminance2)

        return (luminanceLighter + 0.05) / (luminanceDarker + 0.05)
    }

    func contrast(with color: UIColor) -> CGFloat {
        return UIColor.contrast(between: self, and: color)
    }

    func luminance() -> CGFloat {
        // https://www.w3.org/TR/WCAG20-TECHS/G18.html#G18-tests

        let ciColor = CIColor(color: self)

        let components = [ciColor.red, ciColor.green, ciColor.blue]
        let adjusted = components.map { ($0 < 0.03928) ? ($0 / 12.92) : pow(($0 + 0.055) / 1.055, 2.4) }

        return 0.2126 * adjusted[0] + 0.7152 * adjusted[1] + 0.0722 * adjusted[2]
    }
}

// MARK: - Combined Colors [WIP]

public struct ColorGroup {
    let bg: UIColor
    let fg: UIColor

    public init(bg: Int, fg: Int) {
        self.bg = UIColor(bg)
        self.fg = UIColor(fg)
    }

    var contrast: CGFloat { fg.contrast(with: bg) }
}

ColorGroup(bg: 0x123456, fg: 0xabcdef).contrast
ColorGroup(bg: 0xabcdef, fg: 0x123456).contrast
ColorGroup(bg: 0x2E2F31, fg: 0x3283DF).contrast

UIColor.white.luminance()
UIColor.black.luminance()
