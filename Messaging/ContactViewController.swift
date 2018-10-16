//
//  ContactViewController.swift
//  Messaging
//
//  Created by Grant Maloney on 10/15/18.
//  Copyright © 2018 Grant Maloney. All rights reserved.
//

import UIKit

class ContactViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet weak var imageWrapper: UIView!
    @IBOutlet weak var contactImage: UIImageView!
    @IBOutlet weak var contactDetails: UITextView!
    @IBOutlet weak var contactName: UITextField!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var imageHeight: NSLayoutConstraint!
    @IBOutlet weak var imageWidth: NSLayoutConstraint!
    
    @IBAction func deleteImage(_ sender: Any) {
        self.contactImage.image = UIImage(named: "camera")
        imageWidth.constant = 100
        imageHeight.constant = 100
        contactImage.layer.cornerRadius = 0
    }
    @IBAction func updateName(_ sender: Any) {
        self.navigationItem.title = contactName.text
    }
    
    var updateContact: Contact?
    
    @IBAction func createContact(_ sender: Any) {
        if contactImage.image == UIImage(named: "camera") {
            createAlert(message: "You must have a contact image!")
        }
        
        if contactDetails.text == "" {
            createAlert(message: "You must add details for your contact!")
        }
        
        if contactName.text == "" {
            createAlert(message: "You must add a name for your contact!")
        }
        
        if updateContact == nil {
            if let name = contactName.text, let message = contactDetails.text, let image = contactImage.image {
                updateContact = Contact(name: name, message: message, image: image)
            }
        } else {
            if let name = contactName.text, let message = contactDetails.text, let image = contactImage.image {
                updateContact?.update(name: name, message: message, image: image)
            }
        }
        
        do {
            try updateContact?.managedObjectContext?.save()
        } catch {
            print("Failed to save")
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageWrapper.layer.cornerRadius = 75
        createButton.layer.cornerRadius = 5.0
        contactDetails.layer.cornerRadius = 10.0
        
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.openCamera))
        self.imageWrapper.addGestureRecognizer(gesture)
        
        self.contactName.delegate = self
        self.contactDetails.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (updateContact != nil) {
            if let contact = updateContact {
                if let data = contact.image as Data? {
                    contactImage.image = UIImage(data: data)
                }
                
                if let name = contact.name {
                    contactName.text = name
                }
                
                if let message = contact.message {
                    contactDetails.text = message
                }
            }
        }
        
        if (contactImage.image == UIImage(named: "camera")) {
            imageWidth.constant = 100
            imageHeight.constant = 100
            contactImage.layer.cornerRadius = 0
        } else {
            imageWidth.constant = 150
            imageHeight.constant = 150
            contactImage.layer.cornerRadius = 75
        }
        
        self.contactImage.layer.masksToBounds = true
    }
    
    @objc
    func openCamera() {
        if UIImagePickerController.isCameraDeviceAvailable(UIImagePickerController.CameraDevice.front)
            && UIImagePickerController.isCameraDeviceAvailable(UIImagePickerController.CameraDevice.rear) {
            let vc = UIImagePickerController()
            vc.sourceType = .camera
            vc.allowsEditing = true
            vc.delegate = self
            present(vc, animated: true)
        } else {
            let alert = UIAlertController(title: "Camera", message: "This device has no camera.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            
            self.present(alert, animated: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: { () in
            guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
                print("No image found")
                return
            }
            
            self.contactImage.image = image
            self.imageWidth.constant = 150
            self.imageHeight.constant = 150
            self.contactImage.layer.cornerRadius = 75
        })
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    /* Updated for Swift 4 */
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func createAlert(message: String) {
        let alert = UIAlertController(title: "Error!", message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
        self.present(alert, animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
