//
//  CameraViewController.swift
//  Parstagram
//
//  Created by Matthew Nguyen on 5/3/21.
//

import UIKit
import AlamofireImage
import Parse
class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var commentField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onCameraButton(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        } else {
            picker.sourceType = .photoLibrary
        }
        
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info:
        [UIImagePickerController.InfoKey : Any]) {
            let image = info[.editedImage] as! UIImage
            
            let size = CGSize(width: 300, height: 300)
        let scaledImage = image.af.imageScaled(to: size)
            
            imageView.image = scaledImage
            dismiss(animated: true, completion: nil)
        }
    
    
    @IBAction func onSubmitButton(_ sender: Any) {
        let post = PFObject(className: "Post")
        post["user"] = PFUser.current()!
        post["description"] = commentField.text!
        
        let imageData = imageView.image!.pngData()
        let file = PFFileObject(data: imageData!)
        
        post["image"] = file
        
        post.saveInBackground() { (success, error) in
            if success {
                self.dismiss(animated: true, completion: nil)
            } else {
                print("error!")
            }
        }
    }

}
