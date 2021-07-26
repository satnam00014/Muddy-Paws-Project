//
//  ProviderServiceList.swift
//  Muddy Paws
//
//  Created by SatnamSingh on 26/07/21.
//  Copyright © 2021 TechGeeks. All rights reserved.
//

import UIKit
import Firebase
class ProviderServiceList: UIViewController,UITableViewDataSource,UITableViewDelegate{
    
    @IBOutlet weak var table: UITableView!
    var userId : String?
    var serviesName:[String] = []
    var date:[String] = []
    var price:[String] = []
    var detail:[String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Service id : \(userId ?? "")")
        loadData()
        // Do any additional setup after loading the view.
    }
    
    func loadData()  {
        guard let uid = userId else {return}
        Database.database().reference().child("Provider").child("ServicesList").child(uid).getData(completion: {(error,snapshot) in
            guard let serviceIds = snapshot.value as? [String] else {return}
            for serviceId in serviceIds{
                Database.database().reference().child("Services").child(serviceId).getData(completion: {(err,snap) in
                    guard let value = snap.value as? [String:Any?] else {return}
                    let name = value["Name"] as? String
                    let price = value["Price"] as? String
                    let timeStamp = value["TimeStamp"] as? String
                    let detail = value["Detail"] as? String
                    self.serviesName.append(name ?? "")
                    self.price.append(price ?? "")
                    let time = Date(timeIntervalSince1970: Double(timeStamp ?? "") ?? 0)
                    let formatter = DateFormatter()
                    formatter.dateFormat = "dd/MM/yyyy"
                    let date = formatter.string(from: time)
                    self.date.append("\(date)")
                    self.detail.append(detail ?? "")
                    DispatchQueue.main.sync {
                        self.table.reloadData()
                    }
                })
            }
        })
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.serviesName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProviderServiceCell", for: indexPath)
        cell.textLabel?.text = self.serviesName[indexPath.row]
        cell.detailTextLabel?.text = "Date: - \(self.date[indexPath.row])"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detail = self.price[indexPath.row] + "\n" + self.detail[indexPath.row]
        AppDelegate.sharedInstance().alertView(self.serviesName[indexPath.row], message: detail, controller: self)
    }
    
}
