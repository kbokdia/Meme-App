//
//  MemeTableViewController.swift
//  Image Picker
//
//  Created by Kamlesh Bokdia on 16/07/15.
//  Copyright (c) 2015 Kamlesh Bokdia. All rights reserved.
//

import UIKit

class MemeTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var meme = (UIApplication.sharedApplication().delegate as! AppDelegate).meme
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = 100
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "addMeme")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        meme = (UIApplication.sharedApplication().delegate as! AppDelegate).meme
        tableView.reloadData()
    }
    
    func addMeme(){
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meme.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier("tableCell") as! MemeTableCell
        
        let currentMeme = meme[indexPath.row]
        let memeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 12)!,
            NSStrokeWidthAttributeName : -1.5
        ]
        
        //cell.topLabel.attributedText = NSAttributedString(string: currentMeme.top, attributes: memeTextAttributes)
        //cell.bottomLabel.attributedText = NSAttributedString(string: currentMeme.bottom, attributes: memeTextAttributes)
        cell.originalImageView.image = currentMeme.memedImage
        //cell.bringSubviewToFront(cell.topLabel)
        //cell.bringSubviewToFront(cell.bottomLabel)
        cell.mainLabel.text = currentMeme.top + "..." + currentMeme.bottom
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedMeme = meme[indexPath.row]
        let viewMemeController = self.storyboard?.instantiateViewControllerWithIdentifier("ViewMemeController") as! ViewMemeController
        viewMemeController.meme = selectedMeme
        self.navigationController?.pushViewController(viewMemeController, animated: true)
    }

}
