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

protocol Configurator {
    static var reuseId: String { get }
    func configure(view: UIView)
    func registerCell(for table: UITableView)
}

struct CellConfigurator<CellType: Configurable, ModelType: ViewModel>: Configurator where CellType.ModelType == ModelType, CellType: UITableViewCell {

    static var reuseId: String { return String(describing: CellType.self) }

    let model: ModelType

    init(model: ModelType) {
        self.model = model
    }

    func configure(view: UIView) {
        (view as! CellType).configure(model: model)
        print("Configured \(type(of: view)) with reuseId \"\(type(of: self).reuseId)\"")
    }

    func registerCell(for table: UITableView) {
        table.register(CellType.self, forCellReuseIdentifier: type(of: self).reuseId)
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
        label.text = model.id
    }
}

final class FooterCell: UITableViewCell, Configurable {
    let label = UILabel()

    func configure(model: FooterViewModel) {
        label.text = model.id
    }
}

/// The DataSource implementation which uses all of the above logic

final class DataSource: NSObject, UITableViewDataSource {

    let configurators: [Configurator]

    init(configurators: [Configurator]) {
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
        let reuseId = type(of: configurator).reuseId
        let cell =  tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath)
        configurator.configure(view: cell)
        return cell
    }

    public func registerCells(for table: UITableView) {
        configurators.forEach { $0.registerCell(for: table) }
    }
}

/// Some examples

let header = CellConfigurator<HeaderCell, HeaderViewModel>(model: HeaderViewModel(id: "Header"))
let footer = CellConfigurator<FooterCell, FooterViewModel>(model: FooterViewModel(id: "Footer"))
let dataSource = DataSource(configurators: [header, footer])

let table = UITableView(frame: CGRect(x: 0, y: 0, width: 300, height: 500))
dataSource.registerCells(for: table)
table.dataSource = dataSource

PlaygroundPage.current.liveView = table
