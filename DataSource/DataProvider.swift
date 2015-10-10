import Foundation

protocol DataProvider {
	func numberOfSections() -> Int
	func numberOfRowsInSection(section: Int) -> Int
	func objectAtIndexPath(indexPath: NSIndexPath) -> AnyObject
}
