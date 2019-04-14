//
//  String+Extension.swift
//  VinsolApp
//
//  Created by Sunita Moond on 13/04/19.
//  Copyright © 2019 Sunita Moond. All rights reserved.
//

import Foundation
import UIKit


extension String {
    func getTime(_ schedule: Schedule) -> String?{
         let index = schedule.startTime.index(of: ":")
         let index1 = schedule.endTime.index(of: ":")
        guard let startTimeIndex = index, let endTimeIndex = index1 else {
            return schedule.startTime + " - " + schedule.endTime;
        }
        let newStr = schedule.startTime.substring(to: startTimeIndex)
        let  suffix = schedule.startTime.substring(from: startTimeIndex)
        var isPM = (Int(newStr) ?? 0) > 12
        var prefix = (Int(newStr) ?? 0) % 12
        var isNoon = (Int(newStr) ?? 0) == 12
        let str = isPM ? ("\(prefix)" + suffix + "PM") : (isNoon ? schedule.startTime + "PM" : schedule.startTime + "AM");
        let newStr1 = schedule.startTime.substring(to: endTimeIndex)
        let  suffix1 = schedule.startTime.substring(from: endTimeIndex)
        isPM = (Int(newStr1) ?? 0) > 12
        prefix = (Int(newStr1) ?? 0) % 12
        isNoon = (Int(newStr1) ?? 0) == 12
        let str1 = isPM ? ("\(prefix)" + suffix + "PM") : (isNoon ? schedule.endTime + "PM" : schedule.endTime + "AM");


        return str + " - " + str1
    }

    func getTime() -> String{
        let index = self.index(of: ":")

        guard let startTimeIndex = index else {
            return self;
        }
        let newStr = self.substring(to: startTimeIndex)
        let suffix = self.substring(from: startTimeIndex)
        let isPM = (Int(newStr) ?? 0) > 12
        let prefix = (Int(newStr) ?? 0) % 12
        let isNoon = (Int(newStr) ?? 0) == 12
        let str = isPM ? ("\(prefix)" + suffix + "PM") : (isNoon ? self + "PM" : self + "AM");


        return str
    }

    func isLess(str: String) -> Bool {
        let index = self.index(of: ":")
        let index1 = str.index(of: ":")

        guard let indexSelf = index, let  indexAnother = index1 else {
            return true;
        }
        let newStr = self.substring(to: indexSelf)
        let newStr1 = str.substring(to: indexAnother)
        if let range = self.range(of: ":"), let range1 = str.range(of: ":") {
            let suffix = self[range.upperBound...]
            let suffix1 = str[range1.upperBound...]
            if( (Int(newStr) ?? 0)  == (Int(newStr1) ?? 0)){
                return (Int(suffix) ?? 0) < (Int(suffix1) ?? 0)
            }
        }

        print(Int(newStr), Int(newStr1))
        return (Int(newStr) ?? 0) < (Int(newStr1) ?? 0)
    }
    func isGreater(str: String) -> Bool {
        let index = self.index(of: ":")
        let index1 = str.index(of: ":")

        guard let indexSelf = index, let  indexAnother = index1 else {
            return true;
        }
        let newStr = self.substring(to: indexSelf)
        let newStr1 = str.substring(to: indexAnother)
        if let range = self.range(of: ":"), let range1 = str.range(of: ":") {
            let suffix = self[range.upperBound...]
            let suffix1 = str[range1.upperBound...]
            if( (Int(newStr) ?? 0)  == (Int(newStr1) ?? 0)){
                return (Int(suffix) ?? 0) >= (Int(suffix1) ?? 0)
            }
        }

        print(Int(newStr), Int(newStr1))
        return (Int(newStr) ?? 0) >= (Int(newStr1) ?? 0)
    }
}
