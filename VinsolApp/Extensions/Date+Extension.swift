//
//  Date+Extension.swift
//  VinsolApp
//
//  Created by Sunita Moond on 13/04/19.
//  Copyright © 2019 Sunita Moond. All rights reserved.
//

import Foundation
enum DateFormat: String {
//    case api = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
//    case review = "MMM yyyy"
    case api = "dd MMM yyyy"
}

extension Date {
    static let dateFormatter = DateFormatter()

        var localizedDescription: String {
            return description(with: .current)
        }
    

    var tomorrow: Date? {
        return Calendar.current.date(byAdding: .day, value: 1, to: self)
    }
    var yesterday: Date? {
        return Calendar.current.date(byAdding: .day, value: -1, to: self)
    }
    var nexTomorrow: Date? {
        return Calendar.current.date(byAdding: .day, value: 2, to: self)
    }
    var prevYesterday: Date? {
        return Calendar.current.date(byAdding: .day, value: -2, to: self)
    }

    func getTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:MM"
        let calendar = Calendar.current
        let hourComponents = calendar.component(.hour, from: self)
        let minuteComponents = calendar.component(.minute, from: self)
        print(hourComponents)
        print(minuteComponents);
        return ("\(hourComponents):\(minuteComponents)")



//        let date = dateFormatter.dateFromString(string1)
//        let calendar = NSCalendar.currentCalendar()
//        let comp = calendar.components([.Hour, .Minute], fromDate: date)
//        let hour = comp.hour
//        let minute = comp.minute
    }

    func getNextDate(startingDay: Int,endingDay: Int,interval: Int) -> Date?{
        let calendar = Calendar.current
        let components = calendar.dateComponents([.weekday], from: self)
        guard let day = components.weekday else {
            return Calendar.current.date(byAdding: .day, value: 1, to: self)
        }
         let append = (7 - day + 1 + startingDay) % 7;
       
         return Calendar.current.date(byAdding: .day, value: append, to: self)
    }

    func getPrevDate(startingDay: Int,endingDay: Int,interval: Int) -> Date?{

        let calendar = Calendar.current
        let components = calendar.dateComponents([.weekday], from: self)
        guard let day = components.weekday else {
            return Calendar.current.date(byAdding: .day, value: -1, to: self)
        }

        if((day - 2) >= endingDay) {
            var offset = endingDay - day + 2
            return Calendar.current.date(byAdding: .day, value: offset, to: self)
        } else {
            var offset = endingDay - 6  - day
            return Calendar.current.date(byAdding: .day, value: offset, to: self)
        }
    }

    func isValidDay(startingDay: Int,endingDay: Int,interval: Int) -> Bool{
        let days:[String] = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];
        let calendar = Calendar.current
        print(startingDay)
        print(endingDay)
        print(interval)


        let components = calendar.dateComponents([.weekday], from: self)
        guard let day = components.weekday else {
            return false
        }
print((startingDay >= (day - 1) && endingDay <= (day - 1)))
    print(day);
        if (startingDay <= (day - 1) && endingDay >= (day - 1)) {
            return true
        }
        return false;
    }

    func getDay() -> String {
        let calendar = Calendar.current
        let dateComponents = calendar.component(.day, from: self)
        let numberFormatter = NumberFormatter()


         guard let day = numberFormatter.string(from: dateComponents as NSNumber) else { return "0" }
        return day
    }

    func getMonth() -> String {
        let calendar = Calendar.current
        let monthComponents = calendar.component(.month, from: self)
        let numberFormatter = NumberFormatter()


        guard let month = numberFormatter.string(from: monthComponents as NSNumber) else { return "0" }
        return month
    }
    func getYear() -> String {
        let calendar = Calendar.current
        let yearComponents = calendar.component(.year, from: self)
        let numberFormatter = NumberFormatter()


        guard let year = numberFormatter.string(from: yearComponents as NSNumber) else { return "0" }
        return year
    }

    func isMonday() -> Bool{
        let calendar = Calendar.current
        let components = calendar.dateComponents([.weekday], from: self)

         return components.weekday == 2
    }

    func isFriday() -> Bool{
        let calendar = Calendar.current
        let components = calendar.dateComponents([.weekday], from: self)

         return components.weekday == 6
    }

    func getFullDate(_ isTitle: Bool = false, _ isPortrait: Bool = true) -> String {
        let days:[String] = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];
        let calendar = Calendar.current
        let dateComponents = calendar.component(.day, from: self)
        let numberFormatter = NumberFormatter()
        let monthComponents = calendar.component(.month, from: self)
        let yearComponents = calendar.component(.year, from: self)
        let components = calendar.dateComponents([.weekday], from: self)



        guard let day = numberFormatter.string(from: dateComponents as NSNumber), let month = numberFormatter.string(from: monthComponents as NSNumber), let year = numberFormatter.string(from: yearComponents as NSNumber)  else { return "0" }

        let str = days[(components.weekday ?? 1) - 1].uppercased()
         print(components.weekday)

        return isTitle ? (isPortrait ? (day + "-" + month + "-" + year) : (str + ", " + (day + "-" + month + "-" + year))) :(day + "/" + month + "/" + year)

    }

    func getFullDate() -> String {

        let calendar = Calendar.current
        let dateComponents = calendar.component(.day, from: self)
        let numberFormatter = NumberFormatter()
        let monthComponents = calendar.component(.month, from: self)
        let yearComponents = calendar.component(.year, from: self)

        guard let day = numberFormatter.string(from: dateComponents as NSNumber), let month = numberFormatter.string(from: monthComponents as NSNumber), let year = numberFormatter.string(from: yearComponents as NSNumber)  else { return "0" }

        return day + "/" + month + "/" + year

    }
}
