//
//  ViewController.swift
//  Image Picker
//
//  Created by Kamlesh Bokdia on 13/07/15.
//  Copyright (c) 2015 Kamlesh Bokdia. All rights reserved.
//

import UIKit
import AssetsLibrary

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    //Outlets
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var activityButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    //class variable
    var meme:Meme!
    var wasBottomTextFirstResponder:Bool = false
    var previousTopText = ""
    var previousBottomText = ""
    var isEditMemeInvoked = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Initial setup
        imagePickerView.contentMode = UIViewContentMode.ScaleAspectFit
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        
        topTextField.delegate = self
        bottomTextField.delegate = self
        
        let memeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName : -2.5
        ]
        
        topTextField.defaultTextAttributes = memeTextAttributes
        topTextField.textAlignment = NSTextAlignment.Center
        
        bottomTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.textAlignment = NSTextAlignment.Center
        
        saveButton.enabled = false
        activityButton.enabled = false
        
        let singleTap = UITapGestureRecognizer(target: self, action: "singleTapAction:")
        self.view.addGestureRecognizer(singleTap)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
        if isEditMemeInvoked{
            if let newMeme = meme{
                self.imagePickerView.image = newMeme.originalImage
                self.topTextField.text = newMeme.top
                self.previousTopText = newMeme.top
                self.bottomTextField.text = newMeme.bottom
                self.previousBottomText = newMeme.bottom
            }
            else{
                self.imagePickerView.image = nil
                self.topTextField.text = "TOP"
                self.bottomTextField.text = "BOTTOM"
            }
            isEditMemeInvoked = false
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    
    //Save memed Image to the photos application
    @IBAction func saveImage(sender: AnyObject) {
        self.saveMeme()
        let cgiImage = generateMemeImage().CGImage
        let library = ALAssetsLibrary()
        library.writeImageToSavedPhotosAlbum(cgiImage, metadata: nil) { (assetURL:NSURL!, error:NSError!) -> Void in
            if let asset = assetURL{
                let alert = UIAlertView(title: "Success", message: "Image has been saved successfully", delegate: self, cancelButtonTitle: "OK")
                alert.show()
                
            }
            else{
                let alert = UIAlertView(title: "Failure", message: error.description, delegate: self, cancelButtonTitle: "OK")
                alert.show()
            }
        }
    }

    //Choose Image
    @IBAction func pickImage(sender: AnyObject) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        self.presentViewController(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func pickImageFromCamera(sender: AnyObject) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = UIImagePickerControllerSourceType.Camera
        imagePickerController.setEditing(true, animated: true)
        imagePickerController.delegate = self
        self.presentViewController(imagePickerController, animated: true, completion: nil)
    }
    
    //Height adjustments when keyboard is invoked
    func getKeyboardHeight(notification:NSNotification) -> CGFloat{
        let userInfo = notification.userInfo
        let keyBoardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyBoardSize.CGRectValue().height
    }
    
    func keyboardWillShow(notification:NSNotification){
        if bottomTextField.isFirstResponder(){
            self.view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(notification:NSNotification){
        if wasBottomTextFirstResponder{
            self.view.frame.origin.y += getKeyboardHeight(notification)
        }
    }
    
    func subscribeToKeyboardNotifications(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications(){
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    
    //Text Field Delegate Methods
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        dismissKeyboard()
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if topTextField.isFirstResponder(){
            textField.text = previousTopText
        }
        if bottomTextField.isFirstResponder(){
            textField.text = previousBottomText
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if wasBottomTextFirstResponder{
            previousBottomText = textField.text
        }
        else{
            previousTopText = textField.text
        }
    }
    
    //Image Picker Controller delegate methods
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            imagePickerView.image = image
            activityButton.enabled = true
            saveButton.enabled = true
        }
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //Save Meme
    func saveMeme(){
        let memedImage = generateMemeImage()
        let meme = Meme(top: topTextField.text, bottom: bottomTextField.text, originalImage: imagePickerView.image!, memedImage: memedImage)
        (UIApplication.sharedApplication().delegate as! AppDelegate).meme.append(meme)
        
        if (UIApplication.sharedApplication().delegate as! AppDelegate).meme.count > 0{
            cancelButton.enabled = true
        }

    }
    
    //Generating memed image
    func generateMemeImage() -> UIImage{
        //hiding navigation and toolbar
        self.navigationController?.navigationBarHidden = true
        self.toolbar.hidden = true
        
        // Creating screen shot
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //show navigation and toolbar
        self.navigationController?.navigationBarHidden=false
        self.toolbar.hidden = false
        
        return memedImage
    }
    
    //share Image
    @IBAction func shareImage(sender: AnyObject) {
        let memeImage = generateMemeImage()
        let nextController = UIActivityViewController(activityItems: [memeImage], applicationActivities: nil)
        nextController.completionWithItemsHandler = {activity,success,items,error in
            if success{
                self.saveMeme()
            }
        }
        self.presentViewController(nextController, animated: true, completion: nil)
    }
    
    //Tap on screen
    func singleTapAction(recognizer:UITapGestureRecognizer){
        dismissKeyboard()
    }
    
    //Dismiss Keyboard
    func dismissKeyboard(){
        if bottomTextField.isFirstResponder(){
            wasBottomTextFirstResponder = true
        }
        else{
            wasBottomTextFirstResponder = false
        }
        self.view.endEditing(true)
    }
}

