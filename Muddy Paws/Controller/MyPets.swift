//
//  MyPets.swift
//  Muddy Paws
//
//  Created by SatnamSingh on 21/07/21.
//  Copyright © 2021 TechGeeks. All rights reserved.
//

import UIKit
import Firebase

class MyPets: UIViewController ,UITableViewDataSource,UITableViewDelegate{
    
    @IBOutlet weak var table: UITableView!

    var petsName = ["Marrry","Angel","Carl","Rocky"]
    var petId = ["sample","sample","sample","sample"]
    var petDetail = ["","","",""]
    var Uid = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        if let uid = UserDefaults.standard.string(forKey: "UserId"){
            Uid = uid
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadData()
    }
    
    func loadData() {
        guard Uid != "" else {return}
        Database.database().reference().child("Users").child(Uid).child("Pets").getData(completion: {error,snapshot in
            guard let petIds = snapshot.value as? [String] else{print("inside else");return}
            self.petsName = []
            self.petId = []
            self.petDetail = []
            for petid in petIds{
                self.petId.append(petid)
                Database.database().reference().child("Pets").child(petid).child("Name").getData(completion: {(err,snap) in
                    guard let name = snap.value as? String else{return}
                    self.petsName.append(name)
                    DispatchQueue.main.sync {
                        self.table.reloadData()
                    }
                })
                Database.database().reference().child("Pets").child(petid).child("Detail").getData(completion: {(err,snap) in
                    guard let detail = snap.value as? String else{return}
                    self.petDetail.append(detail)
                })
            }
            print(self.petsName)
        })
    }
    
    // MARK:- UITableview
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petsName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyPetsCell", for: indexPath) as! MyPetsCell
        cell.lblPetName.text = petsName[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        AppDelegate.sharedInstance().alertView(self.petsName[indexPath.row], message: self.petDetail[indexPath.row], controller: self)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alert = UIAlertController(title: "Delete", message: "Are you sure to delete note ?", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: {
                _ in
                let id = self.petId[indexPath.row]
                self.petsName.remove(at: indexPath.row)
                self.petId.remove(at: indexPath.row)
                Database.database().reference().child("Pets").child(id).removeValue()
                Database.database().reference().child("Users").child(self.Uid).child("Pets").setValue(self.petId)
                self.table.reloadData()
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func tapMenu(_ sender: Any) {
        AppDelegate.sharedInstance().sideVC?.animateDrawerOpening()
    }
    
    @IBAction func addNewPetButton(_ sender: Any) {
        let addPet = UIStoryboard(name: "User", bundle: nil).instantiateViewController(withIdentifier: "AddPet")
        self.navigationController?.pushViewController(addPet, animated: true)
    }
}

