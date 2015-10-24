//
//  EXMLParserTests.swift
//  EXMLParserTests
//
//  Created by Stone Zhang on 10/22/15.
//  Copyright © 2015 Stone. All rights reserved.
//

import XCTest
import EXMLParser

class EXMLParserTests: XCTestCase, EXMLParserDelegate {
    
    lazy var eparser: EXMLParser! = {
        return EXMLParser.createWithEXMLParserDelegate(self)
    }()
    
    var opfPath: String = ""
    var epubContent: EpubContent = EpubContent()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        XCTAssertTrue(eparser != nil, "Can not create EXMLParser")
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testParseContainerXML() {
        let b =  NSBundle(forClass: EXMLParserTests.self)
        if let url = b.URLForResource("container", withExtension: "xml") {
            eparser.parseXMLFileWithURL(url)
        }
    }
    
    func testParseOPFXML() {
        let b =  NSBundle(forClass: EXMLParserTests.self)
        if let url = b.URLForResource("Naip_9780307776587_epub_opf_r1", withExtension: "opf") {
            eparser.parseXMLFileWithURL(url)
        }
    }
    
    func didParseContainerXML(opfPath: String) {
        XCTAssertEqual(opfPath, "Naip_9780307776587_epub_opf_r1.opf", "Parse container xml failed")
    }
    
    func didParseOPFXML(epubContent: EpubContent) {
        let chapterId = epubContent.spine[0]
        let chapterHref = epubContent.manifest[chapterId]

        XCTAssertEqual(chapterHref, "OEBPS/Naip_9780307776587_epub_cvi_r1.htm", "Parse OPF xml failed")
    }
    
}
