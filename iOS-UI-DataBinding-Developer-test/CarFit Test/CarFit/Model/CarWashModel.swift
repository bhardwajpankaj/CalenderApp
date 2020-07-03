//
//  CarWashModel.swift
//  CarFit
//
//  Created by Pankaj Bhardwaj on 28/06/20.
//  Copyright © 2020 Test Project. All rights reserved.
//

import Foundation

// MARK: - CarWashModel
struct BaseModel<T:Codable>: Codable {
    let success: Bool
    let message: String
    let data: [T]
    let code: Int
}

// MARK: - CarWashVisitModel
struct CarWashVisitModel<Task : Codable>: Codable  {
    let visitId : String
    let homeBobEmployeeId : String
    let houseOwnerId : String
    let isBlocked : Bool
    let startTimeUtc : String
    let endTimeUtc : String
    let title : String
    let isReviewed : Bool
    let isFirstVisit : Bool
    let isManual : Bool
    let visitTimeUsed : Int
    let rememberToday : Bool?
    let houseOwnerFirstName : String
    let houseOwnerLastName : String
    let houseOwnerMobilePhone : String
    let houseOwnerAddress : String
    let houseOwnerZip : String
    let houseOwnerCity : String
    let houseOwnerLatitude : Double
    let houseOwnerLongitude : Double
    let isSubscriber : Bool
    let rememberAlways : Bool?
    let professional : String
    let visitState : String
    let stateOrder : Int
    let expectedTime : String?
    let tasks : [Task]
    let houseOwnerAssets : [String]
    let visitAssets : [String]
    let visitMessages : [String]
}

// MARK: - Task
struct Task: Codable {
    let taskId, title: String
    let isTemplate: Bool
    let timesInMinutes, price: Int
    let paymentTypeId, createDateUtc, lastUpdateDateUtc: String
    let paymentTypes: [String]?
}
