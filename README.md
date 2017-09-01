# UnifyHideBottomBarDemo

### 要实现的效果
首页


----------


![enter image description here](http://oikehvl7k.bkt.clouddn.com/blog_hideTabbar1.png)


----------


跳转到下一个界面


----------


![enter image description here](http://oikehvl7k.bkt.clouddn.com/blog_hideTabbar2.png)


----------
实现代码
```swift
extension UIViewController {
    func pushViewController(_ vc : UIViewController,showTabbar : Bool = true) {
        self.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
        self.hidesBottomBarWhenPushed = !showTabbar
    }
}
```
调用(一行代码即可)
```swift
pushViewController(vc)
```

### 讲解
通常情况下我们在有UITabBarController的时候都需要在A界面跳转到下一个界面B的时候隐藏底部的tabbar,返回A界面的时候又显示tabbar.  
那么我们可以在B界面实现如下的2个方法:

将要显示的时候隐藏tabbar
```swift
override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.tabBarController?.tabBar.isHidden = true
}
```
界面将要消失的时候显示tabbar
```swift
override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    self.tabBarController?.tabBar.isHidden = false
}
```
### 思考
1.这种写法首先不够优雅.
2.跳转的界面多了每个界面都需要实现同样的代码,造成冗余.

针对第一种缺点我们可以有如下更好一点的写法:
在A界面将要跳转到B界面时候(以tableview点击事件为例)
```swift
func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    let b = BViewController()
    // 跳转之前就隐藏tabbar
    self.hidesBottomBarWhenPushed = true
    // 跳转
    navigationController?.pushViewController(b, animated: true)
    // 返回的时候不隐藏tabbar
    self.hidesBottomBarWhenPushed = false
}
```
这样就实现了A跳转B隐藏tabbar,B返回A的时候显示tabbar,此时的方法比viewWillAppear的方式要优雅很多,但是同样的我们需要在每个跳转的地方都这样写也不方便,那么我们不如对其进行封装.
封装可以让我们更简便的调用,但是我们还要考虑到复用的问题,因此我们使用分类的方式
```swift
extension UIViewController {
    func pushViewController(_ vc : UIViewController) {
        self.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
        self.hidesBottomBarWhenPushed = false
    }
}
```
注:一般我们在pushViewController都会选择animated为true,因此不考虑animated参数的封装,直接默认了animated为true.
这样我们在调用的时候就是这样了
```swift
func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    let b = BViewController()
    //注意是pushViewController(b) 而不是self.navigationController?.pushViewController(b),因为里面已经封装了navigationController的跳转
    pushViewController(b)
}
```
到了这里以后我们的需求又来了,此时B界面要跳转到C界面,但是很明显C返回B之后是不能显示tabbar的,如果还是使用这种的封装方式的话,返回的时候是会显示tabbar的,So 我们继续做如下的封装

```swift
extension UIViewController {
    func pushViewControllerWithoutShowTabbar(_ vc : UIViewController) {
        self.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
        // 和上面唯一的区别就是此时的 hidesBottomBarWhenPushed = true 也就是说返回的时候隐藏tabbar
        self.hidesBottomBarWhenPushed = true
    }
}
```

但是实现的方式还是不够优雅,显示与不显示tabbar不同点在于最后的self.hidesBottomBarWhenPushed是true还是false,因此我们进行如下的改进
```swift
extension UIViewController {
    func pushViewController(_ vc : UIViewController,showTabbar : Bool) {
        self.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
        self.hidesBottomBarWhenPushed = showTabbar
    }
}
```
调用的时候是这样的
```swift
pushViewController(b, showTabbar: true)
```
到了这里文章近乎完成,但是并没有;大多数的时候我们使用的都是A跳转到了B隐藏tabbar,返回的时候显示tabbar这种类型,没有必要每次都传递showTabbar: true这个参数,因此此时我们会用到一个Swift中一个很重要的特性,**给参数提供默认值**
给showTabbar 一个默认的值
```swift
extension UIViewController {
    func pushViewController(_ vc : UIViewController,showTabbar : Bool = true) {
        self.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
        self.hidesBottomBarWhenPushed = !showTabbar
    }
}
```
那么我们调用的时候会有两种调用方式
![enter image description here](http://oikehvl7k.bkt.clouddn.com/blog_hideTabbar3.png)
此时我们用一个分类的封装方法就实现了本文所说的功能.

到了这里其实文章还是没有结束,很多时候我们会定义自己的BaseNavigationController.此时我们的隐藏tabbar可以有如下的写法
```swift
class BaseNavViewController: UINavigationController {
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        if self.viewControllers.count > 0{
            viewController.hidesBottomBarWhenPushed = true;
        }
        super.pushViewController(viewController, animated: animated)
    }
}
```
这个在我的Demo里为第三个实现方式.考虑到需要继承UINavigationController,我个人更喜欢上一种方式.

[Demo链接地址](https://github.com/LeaderBoy/UnifyHideBottomBarDemo)


### 总结
本文重点讲解了跳转界面隐藏tabbar的方法.
还有一点没有重点讲解,那就是Swift参数采用默认值,这个细节特别的常用,会在后续的文章进行讲解.

#### 欢迎评论,欢迎提出意见,欢迎更好的想法. 如果喜欢请多多支持 [Two Mins Code](https://leaderboy.github.io/app) – 一个专注于最实用开发技巧的App


