//
//  DayCellViewModel.swift
//  CarFit
//
//  Created by Pankaj Bhardwaj on 30/06/20.
//  Copyright © 2020 Test Project. All rights reserved.
//

import Foundation

struct CalenderDayModel {
    var day:String
    var weekDay: String
}

protocol LoadDayCellData {
    var day: String { get }
    var weekDay: String { get }
}

class DayCellViewModel:LoadDayCellData {
    
    private let date:CalenderDayModel
    init(calenderDayModel:CalenderDayModel) {
        self.date = calenderDayModel
    }
    
    var day: String {
        return self.date.day
    }
    
    var weekDay: String {
        return self.date.weekDay
    }
}
