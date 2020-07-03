//
//  CalendarViewModel.swift
//  CarFit
//
//  Created by Pankaj Bhardwaj on 30/06/20.
//  Copyright © 2020 Test Project. All rights reserved.
//

import Foundation

class CalendarViewModel {
    
    let formatter = DateFormatter()
    var dateCurrent = Date()
    let calendar = Calendar.current
    var monthAndYear:String!

    //MARK:- Get ViewModel Instance
    class func instance()->CalendarViewModel{
        let viewModel = CalendarViewModel()
        
        viewModel.formatter.dateFormat = "MMM yyyy"
        let dateConverted = viewModel.formatter.date(from: viewModel.formatter.string(from: Date()))
        viewModel.monthAndYear = viewModel.formatter.string(from: dateConverted!)
        return viewModel
    }
    
    //MARK:- Handling calender previous and next button
    func nextAndPreviousButtonAction(senderTag:Int) -> String{
        
        formatter.dateFormat = "MMM yyyy"
        // set Previous Month
        if(senderTag == 0) {
            dateCurrent = calendar.date(byAdding: .month, value: -1, to:dateCurrent)!
            monthAndYear = formatter.string(from: dateCurrent)
        }else{
            dateCurrent = calendar.date(byAdding: .month, value: 1, to:dateCurrent)!
            monthAndYear = formatter.string(from: dateCurrent)
        }
        return monthAndYear
    }
    
    //MARK:- Get Number of days in month
    func getCurrentMonthDays()-> Int{
        let interval = calendar.dateInterval(of: .month, for: dateCurrent)! //It will give no of days in a current month
        let days = calendar.dateComponents([.day], from: interval.start, to: interval.end).day!
        return days
    }
    
    func getCurrentDay()->String{
        self.formatter.dateFormat = "dd"
        return self.formatter.string(from: dateCurrent)
    }
    
    // MARK: - Get day to show
    func getCalenderDayModel(_at index:Int) -> CalenderDayModel {
        let index = index + 1
        formatter.dateFormat = "dd MMM yyyy"
        let dateSelected = "\(index) \(self.monthAndYear ?? "")"
        let dateConverted = formatter.date(from: dateSelected)!
        let weekDay = formatter.shortWeekdaySymbols[Calendar.current.component(.weekday, from: dateConverted) - 1]
        let calenderDayModel = CalenderDayModel(day: "\(index)", weekDay: weekDay)
        return calenderDayModel
    }
    
    //MARK:- Get Selected Date
    func getSelectedDate(day:String,monthAndYear:String) -> String {
        formatter.dateFormat = "dd MMM yyyy"
        let dateSelected = "\(day) \(monthAndYear)"
        let dateConverted = formatter.date(from: dateSelected)!
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: dateConverted)
    }
}
