//
//  HomeTableViewCellViewModel.swift
//  CarFit
//
//  Created by Pankaj Bhardwaj on 30/06/20.
//  Copyright © 2020 Test Project. All rights reserved.
//

import Foundation

enum StatusColor:String{
    case done = "Done"
    case inProgress = "InProgress"
    case todo = "ToDo"
    case rejected = "Rejected"
}

protocol LoadCellData {
    var customerName :String {get}
    var status :String {get}
    var distance :String {get set}
    var task :String {get}
    var arrivalTime :String {get}
    var destination :String {get}
    var timeRequired :String {get}
    var lat :Double {get}
    var long :Double {get}
}

final class HomeTableViewCellViewModel:LoadCellData {
    var task: String
    var arrivalTime: String
    var destination: String
    var timeRequired: String
    var customerName: String
       
    private let washModel:CarWashVisitModel<Task>
    
    init(washModel:CarWashVisitModel<Task>) {
        self.washModel = washModel
        self.task = self.washModel.tasks.map{$0.title }.joined(separator: ", ")
        let formatter = DateFormatter()
               formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss" // In this format we are getting Date
               let date = formatter.date(from: self.washModel.startTimeUtc)!
               formatter.dateFormat = "hh:mm" // This is the format we require to show on UI
        self.arrivalTime = formatter.string(from: date) + " \(self.washModel.expectedTime ?? "" )"
        self.destination = "\(self.washModel.houseOwnerAddress )" + " \(self.washModel.houseOwnerZip )" + " \(self.washModel.houseOwnerCity )"
        self.timeRequired = "\(self.washModel.tasks.reduce(0) { $0 + ($1.timesInMinutes )})"
        self.customerName = "\(self.washModel.houseOwnerFirstName )" + " \(self.washModel.houseOwnerLastName )"
    }
    
    var lat: Double {
        return self.washModel.houseOwnerLatitude
    }
    
    var long: Double {
        return self.washModel.houseOwnerLongitude
    }
    
   
    var status: String {
        return self.washModel.visitState
    }
    
    var _distance : String?
    
    var distance: String {
        get {
            return _distance ?? "0"
        }
        set(newValue) {
            _distance = newValue
        }
    }
}
