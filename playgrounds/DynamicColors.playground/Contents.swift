import UIKit

var background: UIColor { UIColor(light: 0xffffff, dark: 0x000000) }
var text: UIColor { UIColor(light: 0x141923, dark: 0x959596) }

extension UIColor {

    // MARK: - Specify All Colors

    convenience init(lightNormal: UIColor, lightHigh: UIColor, darkNormal: UIColor, darkHigh: UIColor) {

        guard #available(iOS 13, *) else {
            self.init(ciColor: lightNormal.ciColor)
            return
        }

        self.init(dynamicProvider: { (traits) in
            switch traits.userInterfaceStyle {
            case .unspecified, .light :
                switch traits.accessibilityContrast {
                case .unspecified, .normal: return lightNormal
                case .high: return lightHigh
                }
            case .dark:
                switch traits.accessibilityContrast {
                case .unspecified, .normal: return darkNormal
                case .high: return darkHigh
                }
            }
        })
    }

    convenience init(lightNormal: Int, lightHigh: Int, darkNormal: Int, darkHigh: Int) {

        self.init(lightNormal: UIColor(lightNormal),
                  lightHigh: UIColor(lightHigh),
                  darkNormal: UIColor(darkNormal),
                  darkHigh: UIColor(darkHigh))
    }

    // MARK: - Specify Light/Dark only

    convenience init(light: UIColor, dark: UIColor) {
        self.init(lightNormal: light, lightHigh: light, darkNormal: dark,darkHigh: dark)
    }

    convenience init(light: Int, dark: Int) {
        self.init(light: UIColor(light), dark: UIColor(dark))
    }

    // MARK: - Helper

    convenience init(red: UInt8, green: UInt8, blue: UInt8) {
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }

    convenience init(_ hex: Int) {
        self.init(red: UInt8((hex >> 16) & 0xFF), green: UInt8((hex >> 8) & 0xFF), blue: UInt8(hex & 0xFF))
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
