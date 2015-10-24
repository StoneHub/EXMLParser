//
//  EXMLParser.swift
//  EXMLParser
//
//  Created by Stone Zhang on 10/22/15.
//  Copyright © 2015 Stone. All rights reserved.
//

import UIKit

public protocol EXMLParserDelegate {
    func didParseContainerXML(opfPath: String)
    func didParseOPFXML(epubContent: EpubContent)
}

public class EXMLParser: NSObject, NSXMLParserDelegate {
    
    private enum ParseProgress {
        case Start, Container, OPF
    }
    
    private var exmlDelegate: EXMLParserDelegate?
    private var parser: NSXMLParser?
    private var epubContent: EpubContent?
    private var itemDictionary: [String: String]?
    private var spineArray: [String]?
    private var opfPath: String?
    private var progress: ParseProgress
    
    private override init() {
        exmlDelegate = nil
        parser = nil
        epubContent = nil
        itemDictionary = nil
        spineArray = nil
        opfPath = nil
        progress = .Start
    }
    
}

// MARK: interface
public extension EXMLParser {
    /// Create an exml parser with exml delegate
    class func createWithEXMLParserDelegate(delegate: EXMLParserDelegate) -> EXMLParser {
        let eparser = EXMLParser()
        eparser.exmlDelegate = delegate
        return eparser
    }
    
    /// Parse xml file with data
    func parseXMLFileWithData(dataXML: NSData) {
        parser = NSXMLParser(data: dataXML)
        parser?.delegate = self
        parser?.parse()
        
        switch progress {
        case .Container:
            exmlDelegate?.didParseContainerXML(opfPath!)
        case .OPF:
            exmlDelegate?.didParseOPFXML(epubContent!)
        default: break
        }
    }
    
    /// Parse xml file with URL
    func parseXMLFileWithURL(urlXML: NSURL) {
        parser = NSXMLParser(contentsOfURL: urlXML)
        parser?.delegate = self
        parser?.parse()
        
        switch progress {
        case .Container:
            exmlDelegate?.didParseContainerXML(opfPath!)
        case .OPF:
            exmlDelegate?.didParseOPFXML(epubContent!)
        default: break
        }
    }
}

// MARK: NSXMLParser Delegate Methods
private extension EXMLParser {
    func parser(parser: NSXMLParser, parseErrorOccurred parseError: NSError) {
        print("Error Occured: \(parseError.description)")
    }
    
    func parserDidStartDocument(parser: NSXMLParser) {
        
    }
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        
        if elementName == "rootfile" {
            opfPath = attributeDict["full-path"]
            progress = .Container
        }
        
        if elementName == "package" {
            epubContent = EpubContent()
        }
        
        if elementName == "manifest" {
            itemDictionary = [String: String]()
        }
        
        if elementName == "item" {
            if let itemKey = attributeDict["id"], itemValue = attributeDict["href"] {
                itemDictionary?.updateValue(itemValue, forKey: itemKey)
            }
        }
        
        if elementName == "spine" {
            spineArray = [String]()
        }
        
        if elementName == "itemref" {
            if let spineItemValue = attributeDict["idref"] {
                spineArray?.append(spineItemValue)
            }
        }
        
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        if elementName == "manifest" {
            epubContent?.manifest = itemDictionary!
        }
        
        if elementName == "spine" {
            epubContent?.spine = spineArray!
        }
        
        if elementName == "package" {
            progress = .OPF
        }
    }
    
    func parserDidEndDocument(parser: NSXMLParser) {
        
    }
}
