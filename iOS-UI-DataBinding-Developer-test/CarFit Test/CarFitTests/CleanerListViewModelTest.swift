//
//  CleanerListViewModelTest.swift
//  CarFitTests
//
//  Created by Pankaj Bhardwaj on 01/07/20.
//  Copyright © 2020 Test Project. All rights reserved.
//

import XCTest
@testable import CarFit

class CleanerListViewModelTest: XCTestCase {

    let viewModel = CleanerListViewModel()

    

    func testJsonFileIsInvalid()  {
        
        let expectations = expectation(description: "Parsing")
        var errorResult : Error!
        viewModel.loadCarWashVisitList(fileName: "carfitTest.json") { (error) in
            errorResult = error
            expectations.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertTrue(errorResult != nil)

    }
    
    func testJsonDataLoadedSuccessfully()  {
        
        let expectations = expectation(description: "Parsing")
        var errorResult : Error!
        viewModel.loadCarWashVisitList(fileName: "carfit.json") { (error) in
            errorResult = error
            expectations.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertTrue(errorResult == nil)

    }
    
    func testViewModelGetDeallocated()  {
           
           let expectations = expectation(description: "Parsing")
           var errorResult : Error!
           CleanerListViewModel().loadCarWashVisitList(fileName: "carfit.json") { (error) in
               errorResult = error
               expectations.fulfill()
           }
           waitForExpectations(timeout: 5, handler: nil)
           XCTAssertTrue(errorResult == nil)

       }
    func testCarWashVisitViewModel()  {
        let expectations = expectation(description: "Parsing")
               var errorResult : Error!
               viewModel.loadCarWashVisitList(fileName: "carfit.json") { (error) in
                   errorResult = error
                   expectations.fulfill()
               }
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertTrue(errorResult == nil)

        viewModel.selectedDate = "2020-07-01"
        let data =  viewModel.getCarWashVisitViewModel(_at: 0)
        XCTAssertTrue(data != nil)
        viewModel.selectedDate = "2020-06-31"

        XCTAssertTrue(viewModel.getCarWashVisitViewModel(_at: 0) == nil)

    }

}
