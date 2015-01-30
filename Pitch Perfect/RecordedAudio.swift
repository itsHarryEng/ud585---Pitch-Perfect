//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Harry Eng on 1/25/15.
//  Copyright (c) 2015 Harry Eng. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject{
    
    var filePathUrl: NSURL!
    var title: String!
    
    init(title:String, url:NSURL) {
        self.title = title
        self.filePathUrl = url
    }
}