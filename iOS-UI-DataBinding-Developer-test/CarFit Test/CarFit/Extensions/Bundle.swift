//
//  Bundle.swift
//  CarFit
//
//  Created by Pankaj Bhardwaj on 29/06/20.
//  Copyright © 2020 Test Project. All rights reserved.
//

import Foundation

enum DecodeError: Error {
    case failToLocate
    case failToLoad
    case failToDecode
    
    var localizedDescription: String {
        var des = ""
        switch self {
        case .failToLocate:
            des = "Invalid File Name , File doesn't exit in Bundle"
        
        case .failToLoad:
            des = "Not able to load data from file"
           
        case .failToDecode:
            des = "Invalid Json"
        }
        return des
    }
}
extension Bundle {
    func decode<T:Codable>(_ file : String) ->  Result<T, DecodeError> {
              guard let url = self.url(forResource: file, withExtension: nil) else {
                return .failure(DecodeError.failToLocate)
               }
               guard let data = try? Data(contentsOf: url) else {
                return .failure(DecodeError.failToLoad)
               }
               let decoder = JSONDecoder()
               guard let loaded = try? decoder.decode(T.self, from: data) else {
                return .failure(DecodeError.failToDecode)
               }
        return .success(loaded)
    }
}
