

import UIKit

// 使用 : 
//1.拖入工程
//2.当需要返回的时候不显示tabbar的时候 : self.pushViewController(otherVC)
//2.当需要返回的时候显示tabbar的时候 :self.pushViewController(otherVC, showTabbar: true)

extension UIViewController {
    func pushViewController(_ vc : UIViewController,showTabbar : Bool = true) {
        hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
        hidesBottomBarWhenPushed = !showTabbar
    }
}

extension UINavigationController {
    
    func pushViewController2(_ vc : UIViewController) {
        if viewControllers.count > 0 {
            hidesBottomBarWhenPushed = true
        }
        self.pushViewController(vc, animated: true)
    }
}

//MARK: 交换两个方法的实现
func exchange(originMethod:Selector,with newMethod:Selector, classInstance: AnyClass) {
    let before : Method  = class_getInstanceMethod(classInstance, originMethod)
    
    let after : Method = class_getInstanceMethod(classInstance, newMethod)
    
    method_exchangeImplementations(before, after)
}



