//
//  CalendarViewModelTest.swift
//  CarFitTests
//
//  Created by Pankaj Bhardwaj on 01/07/20.
//  Copyright © 2020 Test Project. All rights reserved.
//

import XCTest
@testable import CarFit

class CalendarViewModelTest: XCTestCase {
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    let viewModel = CalendarViewModel.instance()
    
    func testNextAndPreviousButtonAction()  {
        
        viewModel.formatter.dateFormat = "MMM yyyy"
        // set Previous Month
        let datePrev = viewModel.calendar.date(byAdding: .month, value: -1, to:Date())!
        let monthAndYearPrev = viewModel.formatter.string(from: datePrev)
        
        // Left Arrow tapped
        XCTAssertEqual(viewModel.nextAndPreviousButtonAction(senderTag: 0), monthAndYearPrev)
        
        let dateNext = viewModel.calendar.date(byAdding: .month, value: 1, to:viewModel.dateCurrent)!
        let monthAndYearNext = viewModel.formatter.string(from: dateNext)
        print("monthAndYearNext",monthAndYearNext)
        let nextMonth = viewModel.nextAndPreviousButtonAction(senderTag: 1)
        // Right Arrow tapped
        XCTAssertEqual(nextMonth, monthAndYearNext)
        
    }
    
    func testGetCurrentMonthDays()  {
        let date = Date()
        let interval = viewModel.calendar.dateInterval(of: .month, for: date)! //It will give no of days in a current month
        let days = viewModel.calendar.dateComponents([.day], from: interval.start, to: interval.end).day!
        XCTAssertEqual(days, viewModel.getCurrentMonthDays())
    }
    
    func testGetCurrentDay()  {
        let date = Date()
        viewModel.formatter.dateFormat = "dd"
        let day = viewModel.formatter.string(from: date)
        XCTAssertEqual(day,viewModel.getCurrentDay())
    }
    func testGetCalenderDayModel()  {

        let day = viewModel.getCalenderDayModel(_at: 0).day // This method gets indepath, so increase them as indexpath starts from 0 but dates are from 1, So ot will result in current month day and weekday
        let weekDay = viewModel.getCalenderDayModel(_at: 0).weekDay
        XCTAssertEqual(day,"1")
        XCTAssertEqual(weekDay,"Wed")
    }
}
