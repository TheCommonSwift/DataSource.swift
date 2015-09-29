import UIKit

protocol TableViewDataSourceDelegate {
	func cellIdentifierForObject(object: AnyObject) -> String?
}

class TableViewDataSource<CellType: UITableViewCell>: NSObject, UITableViewDataSource {
	private let tableView: UITableView
	private let dataProvider: DataProvider
	private let delegate: TableViewDataSourceDelegate?
	private let cellConfigurationHandler: (CellType, AnyObject) -> ()
    private let cellReuseIdentifier: String?
    
	init(tableView tv: UITableView, dataProvider dp: DataProvider, delegate d: TableViewDataSourceDelegate, cellConfigurationHandler h: (CellType, AnyObject) -> ()) {
		tableView = tv
		dataProvider = dp
		delegate = d
		cellConfigurationHandler = h
        cellReuseIdentifier = nil
	}
    
    init(tableView tv: UITableView, dataProvider dp: DataProvider, cellReuseIdentifier id: String, cellConfigurationHandler h: (CellType, AnyObject) -> ()) {
        tableView = tv
        dataProvider = dp
        cellReuseIdentifier = id
        cellConfigurationHandler = h
        delegate = nil
    }
	
    private func reuseIdentifierForObject(object: AnyObject) -> String {
        if let id = cellReuseIdentifier { return id }
        if let d = delegate, let id = d.cellIdentifierForObject(object) { return id }
        fatalError("Either cellReuseIdentifier must be set or cellIdentifierForObject must return an identifier")
    }
    
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return dataProvider.numberOfRowsInSection(section)
	}
	
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return dataProvider.numberOfSections()
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let obj = dataProvider.objectAtIndexPath(indexPath)
		let id = reuseIdentifierForObject(obj)
		guard let cell = tableView.dequeueReusableCellWithIdentifier(id, forIndexPath: indexPath) as? CellType else { fatalError("The dequeued cell has the wrong type") }
        cellConfigurationHandler(cell, obj)
		return cell
	}
}