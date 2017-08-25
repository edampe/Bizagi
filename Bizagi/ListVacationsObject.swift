//
//  ListVacationsObject.swift
//  Bizagi
//
//  Created by Edilberto Amado P on 24/08/17.
//  Copyright © 2017 Edilberto Amado Perdomo. All rights reserved.
//

import Foundation
import ObjectMapper

class ListVacationsObject: Mappable{
    
    var lastVacationOn: String?
    var processId: String?
    var endDate: String?
    var process: String?
    var beginDate: String?
    var activityId: String?
    var requestDate: String?
    var activity: String?
    var employee: String?
    var approved: String?
    
    required init?(map: Map){
    }
    func mapping(map: Map){
        lastVacationOn <- map["lastVacationOn"]
        processId <- map["processId"]
        endDate <- map["endDate"]
        process <- map["process"]
        beginDate <- map["beginDate"]
        activityId <- map["activityId"]
        requestDate <- map["requestDate"]
        activity <- map["activity"]
        employee <- map["employee"]
        approved <- map["approved"]
    }
    
    init( lastVacationOn: String?,
          processId: String?,
          endDate: String?,
          process: String?,
          beginDate: String?,
          activityId: String?,
          requestDate: String?,
          activity: String?,
          employee: String?,
          approved: String?){
        
        self.lastVacationOn = lastVacationOn
        self.processId = processId
        self.endDate = endDate
        self.process = process
        self.beginDate = beginDate
        self.activityId = activityId
        self.requestDate = requestDate
        self.activity = activity
        self.employee = employee
        self.approved = approved
        
    }
    
}




