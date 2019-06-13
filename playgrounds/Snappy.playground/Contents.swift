import UIKit


//enum LayoutEdge: CaseIterable {
//    case leading
//    case trailing
//    case top
//    case bottom
//}

struct LayoutEdge: OptionSet {
    let rawValue: Int

    static let leading    = LayoutEdge(rawValue: 1 << 0)
    static let trailing  = LayoutEdge(rawValue: 1 << 1)
    static let top   = LayoutEdge(rawValue: 1 << 2)
    static let bottom   = LayoutEdge(rawValue: 1 << 3)

    static let all: LayoutEdge = [.leading, .trailing, .top, .bottom]
}

extension UIView {

    func snap(_ edges: LayoutEdge, to snapView: UIView) -> [NSLayoutConstraint] {
        guard superview != nil else { fatalError("Superview has to be set!") }
        guard snapView.superview != nil else { fatalError("SnapView (\(snapView)) has no superview.") }

        var constraints: [NSLayoutConstraint] = []
        if edges.contains(.leading) {
            constraints.append(leadingAnchor.constraint(equalTo: snapView.leadingAnchor))
        } else if edges.contains(.trailing) {
            constraints.append(trailingAnchor.constraint(equalTo: snapView.trailingAnchor))
        } else if edges.contains(.top) {
            constraints.append(topAnchor.constraint(equalTo: snapView.topAnchor))
        } else if edges.contains(.bottom) {
            constraints.append(bottomAnchor.constraint(equalTo: snapView.bottomAnchor))
        }
        return constraints
    }

    func snapToSuper(_ edges: LayoutEdge) -> [NSLayoutConstraint] {
        guard let superview = superview else { fatalError("Superview has to be set!") }
        return snap(edges, to: superview)
    }
}

let constraints = UIView().snap(.all, to: UIView())
let superConstraints = UIView().snapToSuper([.leading, .trailing])


//
//struct EdgeMapping {
//
//    let from: LayoutEdge
//    let to: LayoutEdge
//    let constant: CGFloat
//
//    private init(_ from: LayoutEdge, _ to: LayoutEdge? = nil, const: CGFloat = 0) {
//        self.from = from
//        self.to = to ?? from
//        self.constant = const
//    }
//
//    static func make(_ from: LayoutEdge, _ to: LayoutEdge? = nil, const: CGFloat = 0) -> EdgeMapping {
//        return EdgeMapping(from, to, const: const)
//    }
//}
//
//extension UIView {
//
//    func snap(_ mappingList: [EdgeMapping], of view: UIView? = nil) -> [NSLayoutConstraint] {
//
//        guard superview != nil else {
//            fatalError("Superview has to be non-nil!")
//        }
//
//        guard let snapView = view ?? superview else {
//            return []
//        }
//
//        guard snapView.superview != nil else {
//            fatalError("SnapView (\(snapView)) has no superview.")
//        }
//
//        return mappingList.map {
//            let constraint: NSLayoutConstraint
//            var fromAnchorX: NSLayoutAnchor<NSLayoutXAxisAnchor>?
//            var fromAnchorY: NSLayoutAnchor<NSLayoutYAxisAnchor>?
//            var toAnchorX: NSLayoutAnchor<NSLayoutXAxisAnchor>?
//            var toAnchorY: NSLayoutAnchor<NSLayoutYAxisAnchor>?
//
//
//            switch $0.from {
//            case .leading: fromAnchorX = leadingAnchor
//            case .trailing: fromAnchorX = trailingAnchor
//            case .top: fromAnchorY = topAnchor
//            case .bottom: fromAnchorY = bottomAnchor
//            }
//
//            switch $0.to {
//            case .leading: toAnchorX = snapView.leadingAnchor
//            case .trailing: toAnchorX = snapView.trailingAnchor
//            case .top: toAnchorY = snapView.topAnchor
//            case .bottom: toAnchorY = snapView.bottomAnchor
//            }
//
//            if let fromAnchorX = fromAnchorX, let toAnchorX = toAnchorX {
//                constraint = fromAnchorX.constraint(equalTo: toAnchorX, constant: $0.constant)
//            } else if let fromAnchorY = fromAnchorY, let toAnchorY = toAnchorY {
//                constraint = fromAnchorY.constraint(equalTo: toAnchorY, constant: $0.constant)
//            } else {
//                fatalError("Cannot construct a constraint between X and Y anchors.")
//            }
//            return constraint
//        }
//    }
//}
//
//class SnappyView: UIView {
//
//    let header = UILabel()
//    let body = UILabel()
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//
//        header.text = "Hello!"
//        header.translatesAutoresizingMaskIntoConstraints = false
//        addSubview(header)
//
//        body.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
//        body.translatesAutoresizingMaskIntoConstraints = false
//        addSubview(body)
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    func setupLayoutConstraints() {
//        var constraints: [NSLayoutConstraint] = []
//        constraints += header.snap([.make(.top), .make(.leading), .make(.trailing)])
//        constraints += body.snap([.make(.top, .bottom)], of: header)
//        constraints += body.snap([.make(.bottom), .make(.leading), .make(.trailing)])
//        NSLayoutConstraint.activate(constraints)
//    }
//}
