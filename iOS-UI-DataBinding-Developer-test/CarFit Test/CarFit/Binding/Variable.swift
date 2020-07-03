//
//  Variable.swift
//  PropertySample
//
//  Created by Pankaj Bhardwaj on 02/02/20.
//  Copyright © 2020 Pankaj Bhardwaj. All rights reserved.
//

import Foundation

class Variable<Value> {
    var value : Value {
        didSet {
            if let listner = listner {
                listner(value)
            }
        }
    }
    
    private var listner : ((Value)->Void)?
    func bind(_ callBack:@escaping(Value)->Void){
        self.listner = callBack;
    }
    
     func bindAndFire(_ callBack:@escaping(Value)->Void) {
        self.bind(callBack);
        if let listner = self.listner {
            listner(value)
        }
    }
    
    init(value : Value) {
        self.value = value;
    }
}
