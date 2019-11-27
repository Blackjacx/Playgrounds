import UIKit

@propertyWrapper
struct Trimmed {
    private var value: String = ""

    var wrappedValue: String {
        get { value }
        set { value = newValue.trimmingCharacters(in: .whitespacesAndNewlines) }
    }

    init(wrappedValue initialValue: String) {
        self.wrappedValue = initialValue
    }
}

@propertyWrapper
struct DynamicColor {
    let light: UIColor
    let dark: UIColor

    init(light: UIColor, dark: UIColor) {
        self.light = light
        self.dark = dark
    }

    var wrappedValue: UIColor {
        if #available(iOS 13.0, *) {
            switch UITraitCollection.current.userInterfaceStyle {
            case .dark: return dark
            case .light, .unspecified: return light
            }
        }
        else {
            return light
        }
    }
}

@propertyWrapper
struct UserDefault<T: Codable> {
    let key: String
    let defaultValue: T

    let encoder: JSONEncoder = JSONEncoder()
    let decoder: JSONDecoder = JSONDecoder()

    var wrappedValue: T {
        get {
            guard
                let data = UserDefaults.standard.object(forKey: key) as? Data,
                let object = try? decoder.decode(T.self, from: data) else { return defaultValue }

            return object
        }

        set {
            guard let data = try? encoder.encode(newValue) else { return }
            UserDefaults.standard.set(data, forKey: key)
        }
    }
}

struct Container {
    @Trimmed
    var stringWithWhiteSpaces = "  Hello World!   "

    @DynamicColor(light: .white, dark: .black)
    var color: UIColor

    @UserDefault(key: "dark_mode_on", defaultValue: true)
    var isDarkModeEnabled: Bool
}

let container = Container()

container.stringWithWhiteSpaces
container.color
container.isDarkModeEnabled
