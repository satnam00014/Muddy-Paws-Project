//
//  ProviderUserList.swift
//  Muddy Paws
//
//  Created by SatnamSingh on 26/07/21.
//  Copyright © 2021 TechGeeks. All rights reserved.
//

import UIKit
import Firebase

class ProviderUserList: UIViewController,UITableViewDataSource,UITableViewDelegate {
   
    @IBOutlet weak var table: UITableView!
    var userNames:[String] = []
    var userIds:[String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()

        // Do any additional setup after loading the view.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func loadData()  {
        Database.database().reference().child("Provider").child("ServicesList").getData(completion: {(error,snapshot) in
            let data = snapshot.value as? NSDictionary
            let userIds = (data?.allKeys as? [String]) ?? []
            self.userNames = []
            self.userIds = []
            for id in userIds{
                Database.database().reference().child("Users").child(id).child("Name").getData(completion: {(error,snapshot) in
                    let name = snapshot.value as? String
                    self.userNames.append(name ?? "No name")
                    self.userIds.append(id)
                    DispatchQueue.main.sync {
                        self.table.reloadData()
                    }
                })
            }
            
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.userNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProviderUserCell", for: indexPath)
        cell.textLabel?.text = self.userNames[indexPath.row]
        cell.detailTextLabel?.text = ""
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = UIStoryboard(name: "User", bundle: nil).instantiateViewController(withIdentifier: "ProviderServiceList") as! ProviderServiceList
        user.userId = self.userIds[indexPath.row]
        self.navigationController?.pushViewController(user, animated: true)
    }
    
    @IBAction func logoutButton(_ sender: Any) {
        
        do {
            try Auth.auth().signOut()
            self.navigationController?.popToRootViewController(animated: true)
         } catch let error {
            AppDelegate.sharedInstance().alertView(message: "This is Error", controller: self)
            print("Failed to signout",error)
         }
    }
    
    
}
