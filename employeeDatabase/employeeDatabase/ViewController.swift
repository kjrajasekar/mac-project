//
//  ViewController.swift
//  employeeDatabase
//
//  Created by apple on 17/04/23.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var EmployeeDetailsTableView: UITableView!
    
    var jsonResult : [String : Any] = [String : Any] ()
    var data : [[String : Any]] = [[String : Any]] ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.getMethodAPI()
        self.EmployeeDetailsTableView.delegate = self
        self.EmployeeDetailsTableView.dataSource = self
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "databaseTbCell", for: indexPath) as! databaseTbCell
        cell.empFirstNameLbl.text = "\(self.data[indexPath.row]["first_name"]!)"
        cell.empLastNameLbl.text = "\(self.data[indexPath.row]["last_name"]!)"
        cell.empEmailIdLbl.text = "\(self.data[indexPath.row]["email"]!)"
        
        let Imgurl = URL(string: "\(self.data[indexPath.section]["avatar"]!)")
        let Imgdata = NSData(contentsOf: Imgurl!)
        cell.empAvatarImg.image = UIImage.init(data: Imgdata! as Data)
        
        return cell
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Employee Details"
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 700
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print ("Name: \(self.data[indexPath.row]["first_name"])")
        print ("Email: \(self.data[indexPath.row]["email"]!)")
        // Create new Alert
        var dialogMessage = UIAlertController(title: "\(self.data[indexPath.row]["first_name"]!)", message: "\(self.data[indexPath.row]["email"]!)", preferredStyle: .alert)
        
        // Create OK button with action handler
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            print("Ok button tapped")
         })
        
        //Add OK button to a dialog message
        dialogMessage.addAction(ok)

    }
    
    
    func getMethodAPI() {
        let url = URL(string: "https://reqres.in/api/users?page=1")
        var urlReq = URLRequest(url: url!)
        urlReq.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: urlReq) { data, response, error in
            
            if let err = error {
                print (err.localizedDescription)
                return
            }
            
            if let resp = response as? HTTPURLResponse {
                print (resp.statusCode)
            }
            do {
                self.jsonResult = try JSONSerialization.jsonObject(with: data!) as! [String:Any]
                self.data = self.jsonResult["data"] as! [[String:Any]]
                print(self.data)
            }
            catch let err as NSError {
                print (err.localizedDescription)
            }
            DispatchQueue.main.async {
                self.view.backgroundColor = .cyan
            }
            
        }
        task.resume()
    }
    
}
