//
//  StringDateFormatterTransform.swift
//  JsonMapper
//
//  Created by zhangjia on 2017/2/21.
//  Copyright © 2017年 zhangjia. All rights reserved.
//

import Foundation
import ObjectMapper

class StringDateFormatterTransform: TransformType {
    typealias Object = String
    typealias JSON = Double
    
    let dateFormatter: DateFormatter = DateFormatter()
    
    init() {
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
    }
    
    func transformFromJSON(_ value: Any?) -> String? {
        if let timeInt = value as? Double {
            let date = Date(timeIntervalSince1970: TimeInterval(timeInt))
            return dateFormatter.string(from: date)
        }
        
        if let timeStr = value as? String {
            let date = Date(timeIntervalSince1970: TimeInterval(atof(timeStr)))
            return dateFormatter.string(from: date)
        }
        return nil
    }
    
    func transformToJSON(_ value: String?) -> Double? {
        if let dateString = value {
            if let date = dateFormatter.date(from: dateString) {
                return Double((date.timeIntervalSince1970))
            }
        }
        return nil
    }
}
