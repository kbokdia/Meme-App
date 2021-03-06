//
//  ViewMemeController.swift
//  Image Picker
//
//  Created by Kamlesh Bokdia on 17/07/15.
//  Copyright (c) 2015 Kamlesh Bokdia. All rights reserved.
//

import UIKit

class ViewMemeController: UIViewController {

    //var
    var meme:Meme!
    
    //IBOutlets
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: UIBarButtonItemStyle.Plain, target: self, action: "editMeme")
        
        imageView.image = meme.memedImage
    }
    
    func editMeme(){
        let editMemeNavController = self.storyboard?.instantiateViewControllerWithIdentifier("memeEditor") as! UINavigationController
        
        let editMemeViewController = editMemeNavController.viewControllers[0] as! MemeEditorViewController
        
        editMemeViewController.meme = meme
        editMemeViewController.isEditMemeInvoked = true
        self.presentViewController(editMemeNavController, animated: true) { () -> Void in
            self.navigationController?.popToRootViewControllerAnimated(true)
        }
    }
    
}
