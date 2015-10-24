//
//  EpubContent.swift
//  EXMLParser
//
//  Created by Stone Zhang on 10/22/15.
//  Copyright © 2015 Stone. All rights reserved.
//

import Foundation

public class EpubContent {
    public var manifest: [String: String]
    public var spine: [String]
    
    public init() {
        manifest = [String: String]()
        spine = [String]()
    }
}