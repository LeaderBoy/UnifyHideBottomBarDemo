
import UIKit

// 使用: 
// 在TabbarViewController中使用的是 BaseNavViewController
// var viewControllersArray = [BaseNavViewController]()
// 调用  self.navigationController?.pushViewController(otherVC, animated: true)
class BaseNavViewController: UINavigationController {
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        if self.viewControllers.count > 0{
            viewController.hidesBottomBarWhenPushed = true;
        }
        super.pushViewController(viewController, animated: animated)
    }
}
