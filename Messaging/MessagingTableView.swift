//
//  MessagingTableView.swift
//  Messaging
//
//  Created by Grant Maloney on 10/15/18.
//  Copyright © 2018 Grant Maloney. All rights reserved.
//

import UIKit
import CoreData

class MessagingTableView: UITableViewController {

    @IBAction func addContact(_ sender: Any) {
        self.performSegue(withIdentifier: "createContact", sender: self)
    }
    
    var contacts: [Contact] = []
    let formatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        formatter.dateFormat = "h:mm a"

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadContacts()
    }

    // MARK: - Table view data source

    func loadContacts() {
        contacts = []
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Contact> = Contact.fetchRequest()
        
        do {
            contacts = try managedContext.fetch(fetchRequest)
            self.tableView.reloadData()
        } catch {
            print("Error loading contacts!")
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return contacts.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contact", for: indexPath)

        if let cell = cell as? MessagingCell {
            if let data = contacts[indexPath.row].image as Data? {
                cell.contactImage.image = UIImage(data: data)
                cell.contactImage.layer.cornerRadius = 25
                cell.contactImage.layer.masksToBounds = true
            }
            
            cell.contactName.text = contacts[indexPath.row].name?.capitalized
            cell.contactDescription.text = contacts[indexPath.row].message
            cell.time.text = formatter.string(for: contacts[indexPath.row].modifiedDate)
        }
        // Configure the cell...

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "updateContact", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "updateContact" {
                if let destination = segue.destination as? ContactViewController {
                    if let row = self.tableView.indexPathForSelectedRow?.row {
                        destination.updateContact = self.contacts[row]
                    }
                }
            }
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let contact = self.contacts[indexPath.row]
            let context = contact.managedObjectContext
            do {
                contact.managedObjectContext?.delete(contact)
                try context?.save()
                self.contacts.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .fade)
            } catch {
                print("Failed to delete contact!")
                self.tableView.reloadData()
            }
        }
    }
 

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
