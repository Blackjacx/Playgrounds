import UIKit
import PlaygroundSupport

/// A view model protocol and an implementation

protocol ViewModel {
    var id: String { get }
}

struct HeaderViewModel: ViewModel {
    let id: String
}

struct FooterViewModel: ViewModel {
    let id: String
}

/// The CellConfigurator protocol and a UITableView implementation

protocol CellConfigurator {
    static var reuseId: String { get }
    func configure(cell: UITableViewCell?) -> UITableViewCell
}

struct DefaultConfigurator<CellType: Configurable, ModelType: ViewModel>: CellConfigurator where CellType.ModelType == ModelType, CellType: UITableViewCell {

    static var reuseId: String { return String(describing: CellType.self) }

    let model: ModelType

    init(model: ModelType) {
        self.model = model
    }

    func configure(cell: UITableViewCell?) -> UITableViewCell {
        let resolvedCell: UITableViewCell

        if let cell = cell {
            resolvedCell = cell
        } else {
            resolvedCell = CellType.self(style: .default, reuseIdentifier: type(of: self).reuseId)
        }
        (resolvedCell as! CellType).configure(model: model)
        return resolvedCell
    }
}

/// A protocol (which is to be adopted by views) and 2 cells that conform to it

protocol Configurable: class {
    associatedtype ModelType
    func configure(model: ModelType)
}

final class HeaderCell: UITableViewCell, Configurable {
    let label = UILabel()

    func configure(model: HeaderViewModel) {
        print("Configured \(type(of: self))")
        label.text = model.id
    }
}

final class FooterCell: UITableViewCell, Configurable {
    let label = UILabel()

    func configure(model: FooterViewModel) {
        print("Configured \(type(of: self))")
        label.text = model.id
    }
}

/// The DataSource implementation which uses all of the above logic

final class DataSource: NSObject, UITableViewDataSource {

    let configurators: [CellConfigurator]

    init(configurators: [CellConfigurator]) {
        self.configurators = configurators
        super.init()
    }

    @available(*, unavailable, message:"init() has not been implemented")
    override init() {
        fatalError()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return configurators.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let configurator = configurators[indexPath.row]
        let cell =  tableView.dequeueReusableCell(withIdentifier: type(of: configurator).reuseId)
        return configurator.configure(cell: cell)
    }
}

/// Some examples

let header = DefaultConfigurator<HeaderCell, HeaderViewModel>(model: HeaderViewModel(id: "Header"))
let footer = DefaultConfigurator<FooterCell, FooterViewModel>(model: FooterViewModel(id: "Footer"))
let dataSource = DataSource(configurators: [header, footer])

let table = UITableView(frame: CGRect(x: 0, y: 0, width: 300, height: 500))
table.dataSource = dataSource

PlaygroundPage.current.liveView = table
