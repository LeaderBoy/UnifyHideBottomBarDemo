
import UIKit

class ViewController: UIViewController {
    
    lazy var tableView : UITableView = {
        $0.tableFooterView      = UIView()
        return $0
    }(UITableView(frame: .zero, style: .plain))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        
    }
    
    override func viewDidLayoutSubviews() {
        tableView.frame = view.bounds
    }
    
    
}
extension ViewController : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let otherVC = OtherViewController()
//MARK: 方法二:
//        self.hidesBottomBarWhenPushed = true
//        navigationController?.pushViewController(otherVC, animated: true)
//        self.hidesBottomBarWhenPushed = false
        
        
//MARK: 方法三 :
//        self.navigationController?.pushViewController(otherVC, animated: true)
        
        
//MARK: 方法四 : 
        self.pushViewController(otherVC)
        
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cellID")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cellID")
        }
        cell?.textLabel?.text = "测试" + "\(indexPath.row)"
        return cell!
    }
}






