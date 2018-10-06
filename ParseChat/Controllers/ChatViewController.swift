//
//  ChatViewController.swift
//  ParseChat
//
//  Created by Sanaz Khosravi on 9/19/18.
//  Copyright © 2018 GirlsWhoCode. All rights reserved.
//

import UIKit
import Parse
import AlamofireImage

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var myTableView: UITableView!
    @IBOutlet var chatText: UITextField!
    var messages: [PFObject] = []
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.myTableView.delegate = self
        self.myTableView.dataSource = self
        myTableView.separatorStyle = .none
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        myTableView.insertSubview(refreshControl, at: 0)
        myTableView.insertSubview(refreshControl, at: 0)
        myTableView.rowHeight = UITableViewAutomaticDimension
        myTableView.estimatedRowHeight = 50
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer: Timer) in
            self.pullDownQueries()
        }
       
        
    }
    
    @objc func refreshControlAction(_ refreshControl: UIRefreshControl) {
        pullDownQueries()
    }
    
    func pullDownQueries() {
        let query = PFQuery(className:"Message")
        query.order(byDescending: "createdAt")
        query.includeKey("user")
        query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
            if let objects = objects {
                self.messages = objects
                self.myTableView.reloadData()
                self.refreshControl.endRefreshing()
            } else {
                print(error?.localizedDescription ?? "")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sendButtonAction(_ sender: Any) {
        
        let chatMessage = PFObject(className: "Message")
        
        chatMessage["text"] = chatText.text ?? ""
        
        chatMessage.saveInBackground { (success, error) in
            if success {
                self.createAlert("Success", "The message was saved!")
                self.chatText.text = ""
            } else if let error = error {
                self.createAlert("Error", error.localizedDescription)
                
            }
        }
    }
    
    
    
    func createAlert(_ titleT : String, _ messageT : String){
        let alert = UIAlertController(title: titleT, message:
            messageT, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler:nil))
        self.present(alert, animated: true, completion: nil)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myTableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath) as! ChatTableViewCell
        
        cell.avatarImage.layer.cornerRadius = cell.avatarImage.frame.height / 2
        cell.avatarImage.clipsToBounds = true
        
        let chatMessage = messages[indexPath.row]
        if let msg = chatMessage["text"] as? String {
            cell.chatCell.text = msg
        } else {
            cell.chatCell.text = ""
        }
        

        
        
        if let user = chatMessage["user"] as? PFUser {
            cell.userNameLabel.text = user.username
            let baseURL = "https://api.adorable.io/avatars/"
            let identifier = user.username!
            if(identifier != "🤖"){
                let path = "100/\(String(describing: identifier))"
                let avatarURL = URL(string: baseURL+path)
                if(avatarURL != nil){
                    cell.avatarImage.af_setImage(withURL: avatarURL!)
                }else{
                    cell.avatarImage.image = #imageLiteral(resourceName: "default-placeholder")
                }
            }
               
        }else {
            cell.userNameLabel.text = "🤖"
            cell.avatarImage.image = #imageLiteral(resourceName: "default-placeholder")
        }
        
        return cell
    }
}
