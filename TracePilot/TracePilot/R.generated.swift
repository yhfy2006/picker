// This is a generated file, do not edit!
// Generated by R.swift, see https://github.com/mac-cain13/R.swift

import UIKit

struct R {
  static func validate() {
    storyboard.main.validateImages()
    storyboard.main.validateViewControllers()
  }
  
  struct image {
    static var appIcon: UIImage? { return UIImage(named: "AppIcon") }
  }
  
  struct nib {
    static var launchScreen: _R.nib._LaunchScreen { return _R.nib._LaunchScreen() }
  }
  
  struct reuseIdentifier {
    
  }
  
  struct segue {
    
  }
  
  struct storyboard {
    struct main {
      static var sessionVC: UIViewController? { return instance.instantiateViewControllerWithIdentifier("SessionVC") as? UIViewController }
      static var historyVC: UIViewController? { return instance.instantiateViewControllerWithIdentifier("HistoryVC") as? UIViewController }
        
      static var initialViewController: UINavigationController? { return instance.instantiateInitialViewController() as? UINavigationController }
      static var instance: UIStoryboard { return UIStoryboard(name: "Main", bundle: nil) }

      
      static func validateImages() {
        
      }
      
      static func validateViewControllers() {
        assert(spaceshipsVC != nil, "[R.swift] ViewController with identifier 'spaceshipsVC' could not be loaded from storyboard 'Main' as 'UIViewController'.")
        assert(crewVC != nil, "[R.swift] ViewController with identifier 'crewVC' could not be loaded from storyboard 'Main' as 'UIViewController'.")
      }
    }
  }
}

struct _R {
  struct nib {
    struct _LaunchScreen: NibResource {
      var instance: UINib { return UINib.init(nibName: "LaunchScreen", bundle: nil) }
      
      func firstView(ownerOrNil: AnyObject?, options optionsOrNil: [NSObject : AnyObject]?) -> UIView? {
        return instantiateWithOwner(ownerOrNil, options: optionsOrNil)[0] as? UIView
      }
      
      func instantiateWithOwner(ownerOrNil: AnyObject?, options optionsOrNil: [NSObject : AnyObject]?) -> [AnyObject] {
        return instance.instantiateWithOwner(ownerOrNil, options: optionsOrNil)
      }
    }
  }
}

struct ReuseIdentifier<T>: Printable {
  let identifier: String
  
  var description: String { return identifier }
}

protocol NibResource {
  var instance: UINib { get }
}

protocol Reusable {
  typealias T
  
  var reuseIdentifier: ReuseIdentifier<T> { get }
}

extension UITableView {
  func dequeueReusableCellWithIdentifier<T : UITableViewCell>(identifier: ReuseIdentifier<T>, forIndexPath indexPath: NSIndexPath?) -> T? {
    if let indexPath = indexPath {
      return dequeueReusableCellWithIdentifier(identifier.identifier, forIndexPath: indexPath) as? T
    }
    return dequeueReusableCellWithIdentifier(identifier.identifier) as? T
  }
  
  func dequeueReusableCellWithIdentifier<T : UITableViewCell>(identifier: ReuseIdentifier<T>) -> T? {
    return dequeueReusableCellWithIdentifier(identifier.identifier) as? T
  }
  
  func dequeueReusableHeaderFooterViewWithIdentifier<T : UITableViewHeaderFooterView>(identifier: ReuseIdentifier<T>) -> T? {
    return dequeueReusableHeaderFooterViewWithIdentifier(identifier.identifier) as? T
  }
  
  func registerNib<T: NibResource where T: Reusable, T.T: UITableViewCell>(nibResource: T) {
    registerNib(nibResource.instance, forCellReuseIdentifier: nibResource.reuseIdentifier.identifier)
  }
  
  func registerNibForHeaderFooterView<T: NibResource where T: Reusable, T.T: UIView>(nibResource: T) {
    registerNib(nibResource.instance, forHeaderFooterViewReuseIdentifier: nibResource.reuseIdentifier.identifier)
  }
  
  func registerNibs<T: NibResource where T: Reusable, T.T: UITableViewCell>(nibResources: [T]) {
    nibResources.map(registerNib)
  }
}

extension UICollectionView {
  func dequeueReusableCellWithReuseIdentifier<T: UICollectionViewCell>(identifier: ReuseIdentifier<T>, forIndexPath indexPath: NSIndexPath) -> T? {
    return dequeueReusableCellWithReuseIdentifier(identifier.identifier, forIndexPath: indexPath) as? T
  }
  
  func dequeueReusableSupplementaryViewOfKind<T: UICollectionReusableView>(elementKind: String, withReuseIdentifier identifier: ReuseIdentifier<T>, forIndexPath indexPath: NSIndexPath) -> T? {
    return dequeueReusableSupplementaryViewOfKind(elementKind, withReuseIdentifier: identifier.identifier, forIndexPath: indexPath) as? T
  }
  
  func registerNib<T: NibResource where T: Reusable, T.T: UICollectionViewCell>(nibResource: T) {
    registerNib(nibResource.instance, forCellWithReuseIdentifier: nibResource.reuseIdentifier.identifier)
  }
  
  func registerNib<T: NibResource where T: Reusable, T.T: UICollectionReusableView>(nibResource: T, forSupplementaryViewOfKind kind: String) {
    registerNib(nibResource.instance, forSupplementaryViewOfKind: kind, withReuseIdentifier: nibResource.reuseIdentifier.identifier)
  }
  
  func registerNibs<T: NibResource where T: Reusable, T.T: UICollectionViewCell>(nibResources: [T]) {
    nibResources.map(registerNib)
  }
  
  func registerNibs<T: NibResource where T: Reusable, T.T: UICollectionReusableView>(nibResources: [T], forSupplementaryViewOfKind kind: String) {
    nibResources.map { self.registerNib($0, forSupplementaryViewOfKind: kind) }
  }
}