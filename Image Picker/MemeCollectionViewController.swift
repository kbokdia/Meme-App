//
//  MemeCollectionViewController.swift
//  Image Picker
//
//  Created by Kamlesh Bokdia on 16/07/15.
//  Copyright (c) 2015 Kamlesh Bokdia. All rights reserved.
//

import UIKit

class MemeCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    var meme = (UIApplication.sharedApplication().delegate as! AppDelegate).meme
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Your Memes"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "addMeme")
    }
    
    func addMeme(){
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return meme.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        collectionView.registerClass(MemeCollectionViewCell.self, forCellWithReuseIdentifier: "collectionCell")
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("collectionCell", forIndexPath: indexPath) as! MemeCollectionViewCell
        
        let memeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 12)!,
            NSStrokeWidthAttributeName : -1.5
        ]
        
        let currentMeme = meme[indexPath.row]
        cell.topLabel.attributedText = NSAttributedString(string: currentMeme.top, attributes: memeTextAttributes)
        cell.bottomLabel.attributedText = NSAttributedString(string: currentMeme.bottom, attributes: memeTextAttributes)
        cell.originalImage.image = currentMeme.originalImage
        
        return cell
    }
    //On select
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let selectedMeme = meme[indexPath.row]
        let viewMemeController = self.storyboard?.instantiateViewControllerWithIdentifier("ViewMemeController") as! ViewMemeController
        viewMemeController.meme = selectedMeme
        self.navigationController?.pushViewController(viewMemeController, animated: true)
    }
    
    //To Show 3 items per row
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let size = CGSize(width: (collectionView.frame.size.width - 20)/3, height: 100)
        return size
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 1
    }
}
