//
//  Meme.swift
//  Image Picker
//
//  Created by Kamlesh Bokdia on 16/07/15.
//  Copyright (c) 2015 Kamlesh Bokdia. All rights reserved.
//

import UIKit

class Meme {
    
    var top:String!
    var bottom:String!
    var originalImage:UIImage!
    var memedImage:UIImage!
    
    init(top:String,bottom:String,originalImage:UIImage,memedImage:UIImage){
        self.top = top
        self.bottom = bottom
        self.originalImage = originalImage
        self.memedImage = memedImage
    }
}
