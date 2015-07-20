//
//  MemeCollectionViewCell.swift
//  Image Picker
//
//  Created by Kamlesh Bokdia on 16/07/15.
//  Copyright (c) 2015 Kamlesh Bokdia. All rights reserved.
//

import UIKit

class MemeCollectionViewCell: UICollectionViewCell {

    var originalImage: UIImageView!
    var topLabel: UILabel!
    var bottomLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        originalImage = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        originalImage.contentMode = UIViewContentMode.ScaleToFill
        contentView.addSubview(originalImage)
        
        topLabel = UILabel(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: (frame.size.height * 0.15)))
        topLabel.textAlignment = NSTextAlignment.Center
        contentView.addSubview(topLabel)
        
        bottomLabel = UILabel(frame: CGRect(x: 0, y: (frame.size.height - (frame.size.height * 0.15)), width: frame.size.width, height: (frame.size.height * 0.15)))
        bottomLabel.textAlignment = NSTextAlignment.Center
        contentView.addSubview(bottomLabel)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
