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
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: UIBarButtonItemStyle.Plain, target: self, action: "editMeme")
        
        let memeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName : -1.5
        ]
        
        imageView.image = meme.originalImage
        topLabel.attributedText = NSAttributedString(string: meme.top, attributes: memeTextAttributes)
        bottomLabel.attributedText = NSAttributedString(string: meme.bottom, attributes: memeTextAttributes)
    }
    
    func editMeme(){
        let editMemeViewController = self.navigationController?.viewControllers[0] as! ViewController
        editMemeViewController.meme = self.meme
        editMemeViewController.isEditMemeInvoked = true
        self.navigationController?.popToViewController(editMemeViewController, animated: true)
    }
    
}
