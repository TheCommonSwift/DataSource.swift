import UIKit

class CollectionViewDataSource<CellType: UICollectionViewCell, ObjectType>:
NSObject, UICollectionViewDataSource {
    private let cellConfigurationHandler: (CellType, ObjectType) -> ()
    private let cellIdentifierHandler: (ObjectType) -> String
    private let view: UIView
    private let dataProvider: DataProvider
    init(view v: UIView,
        dataProvider dp: DataProvider,
        cellIdentifierHandler ih: (ObjectType) -> String,
        cellConfigurationHandler h: (CellType, ObjectType) -> ()) {
            view = v
            dataProvider = dp
            cellIdentifierHandler = ih
            cellConfigurationHandler = h
    }

	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return dataProvider.numberOfRowsInSection(section)
	}
	func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
		return dataProvider.numberOfSections()
	}
	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath
        indexPath: NSIndexPath) -> UICollectionViewCell {
        guard let obj = dataProvider.objectAtIndexPath(indexPath) as? ObjectType else {
            return UICollectionViewCell()
        }
        let id = cellIdentifierHandler(obj)
        guard let cell = collectionView.dequeueReusableCellWithReuseIdentifier(id,
            forIndexPath: indexPath) as? CellType else { return UICollectionViewCell() }
        cellConfigurationHandler(cell, obj)
		return cell
	}
}
