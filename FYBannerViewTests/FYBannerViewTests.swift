//
//  FYBannerViewTests.swift
//  FYBannerViewTests
//
//  Created by 武飞跃 on 2017/4/10.
//  Copyright © 2017年 武飞跃. All rights reserved.
//

import XCTest
@testable import FYBannerView

class FYBannerViewTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testControlStyle(){
        
        /*
         var borderWidth:CGFloat = 2
         var width:CGFloat = 8
         var height:CGFloat = 8
         var margin:CGFloat = 10
         */
        
        let controlStyle = FYControlStyle()
        
        let point = controlStyle.calcDotPosition(index: 1)
        let size = controlStyle.calcDotSize(num: 2)
        
        XCTAssertEqual(point, CGPoint(x:22, y:2))
        XCTAssertEqual(size, CGSize(width:34, height:8 + 2 * 2))
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
