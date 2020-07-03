//
//  CleanerListViewModel.swift
//  CarFit
//
//  Created by Pankaj Bhardwaj on 28/06/20.
//  Copyright © 2020 Test Project. All rights reserved.
//

import Foundation
import CoreLocation

class CleanerListViewModel {
    
    var dictOfVisitModelArray:Variable<[String:[LoadCellData]]> = Variable(value: [String:[LoadCellData]]())
    var selectedDate = String()
    
    
    var loadJsonWorkItem : DispatchWorkItem!
    //MARK:- Get Car Wash Visits
    func loadCarWashVisitList(fileName:String = "carfit.json",completionHandler:((_ error:Error?)->Void)?) {
        loadJsonWorkItem?.cancel()
        loadJsonWorkItem  = DispatchWorkItem.init { [weak self] in
            guard let self = self else {
                if let completion = completionHandler {
                    completion(nil)
                }
                
                return }
            let result : Result<BaseModel<CarWashVisitModel<Task>>,DecodeError> =  Bundle.main.decode(fileName)
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
                if let completion = completionHandler {
                    completion(error)
                }
                
                
            case .success(let carWashModel):
                let carWashVisitModelArray : [CarWashVisitModel<Task>] = carWashModel.data
                var dictOfVisitModelArray = [String:[LoadCellData]]()
                
                // Creating a dictionary of Array(CarWashVisitModel) with keys as per date, so that they will be easy to get visits array on any date
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                
                let keyDateFormatter = DateFormatter()
                keyDateFormatter.dateFormat = "yyyy-MM-dd"
                
                for i in 0 ..< carWashVisitModelArray.count{
                    let carWashVisitModel:CarWashVisitModel<Task> = carWashVisitModelArray[i]
                    
                    let cellModel = HomeTableViewCellViewModel.init(washModel: carWashVisitModel)
                    
                    if let date = dateFormatter.date(from: carWashVisitModel.startTimeUtc) {
                        let dateAsKey = keyDateFormatter.string(from: date)
                        if(dictOfVisitModelArray.keys.contains(dateAsKey)){
                            dictOfVisitModelArray[dateAsKey]?.append(cellModel)
                        }else
                        {
                            dictOfVisitModelArray[dateAsKey] = [cellModel]
                        }
                    }
                }
                DispatchQueue.main.async {
                    self.dictOfVisitModelArray.value = dictOfVisitModelArray
                }
                if let completion = completionHandler {
                    completion(nil)
                }
            }
        }
        DispatchQueue.global().async(execute: loadJsonWorkItem)
    }
    
    // MARK: - Get Visits count on selected date
    func numberOfRows()->Int {
        return self.dictOfVisitModelArray.value[self.selectedDate]?.count ?? 0
    }
    
    // MARK: - Get single Visit data
    func getCarWashVisitViewModel(_at index:Int) -> LoadCellData? {
        var loadCellData = self.dictOfVisitModelArray.value[self.selectedDate]?[index]
        loadCellData?.distance = getDistanceFromPreviousVisit(_at: index)
        return loadCellData
    }
    
    // MARK: - Get Visits on selected date
    private func getCarWashViewModel() -> [LoadCellData] {
        return self.dictOfVisitModelArray.value[self.selectedDate] ?? []
    }
    
    //MARK:- Get distance between two visits
    private func getDistanceFromPreviousVisit(_at index:Int) -> String {
        
        if index == 0 {
            return "0"
        }else {
            let myLocation = CLLocation(latitude: getCarWashViewModel()[index].lat , longitude: getCarWashViewModel()[index].long )
            let previousVisitLocation = CLLocation(latitude: getCarWashViewModel()[index - 1].lat , longitude: getCarWashViewModel()[index - 1].long )
            //Measuring distance in km
            let distance = myLocation.distance(from: previousVisitLocation) / 1000
            return distance == 0.0 ? "0" : (String(format: "%.01f", distance))
        }
    }
}
