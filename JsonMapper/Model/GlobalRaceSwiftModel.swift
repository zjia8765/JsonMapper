//
//  GlobalRaceSwiftModel.swift
//  JsonMapper
//
//  Created by zhangjia on 2017/2/21.
//  Copyright © 2017年 zhangjia. All rights reserved.
//

import Foundation
import ObjectMapper


class RaceSourceSwiftModel : Mappable {
    var id:String!
    var name:String!
    var desc:String?
    var imageId:String!
    var count:Int = 0
    var filter:Int = 0
    var star:Bool = false
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        id          <- map["id"]
        name        <- map["name"]
        desc        <- map["desc"]
        imageId     <- map["imageId"]
        count       <- map["count"]
        filter      <- map["filter"]
        star        <- map["star"]
    }
}

class GlobalRaceSwiftModel : Mappable {
    var id:String!
    var url:String = ""
    var title:String!
    var imageId:String!
    var timestamp:CLongLong = 0
    var timesDate:String?
    var like:Int = 0
    var score:String?
    var source:RaceSourceSwiftModel!
    
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        id          <- map["id"]
        url         <- map["url"]
        title       <- map["title"]
        imageId     <- map["imageId"]
        timestamp   <- map["timestamp"]
        timesDate   <- (map["timestamp"], StringDateFormatterTransform())
        like        <- map["like"]
        score       <- map["score"]
        source      <- map["source"]
    }
}
