//
//  MSCalendarTool.swift
//  MSCalendar_Example
//
//  Created by marshal on 2021/2/28.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit

public struct MSCalendarTool {
    public static let ms_localCalendar = Calendar.init(identifier: Calendar.Identifier.gregorian)
    public static let ms_lonCalendar = Calendar.init(identifier: Calendar.Identifier.chinese)
    static let ms_weekDayInEnglish = ["Sun", "Mon", "Tues", "Wed", "Thur", "Fri", "Sat"]
    static let ms_MonthInEnglish = ["Jan.", "Feb.", "Mar.", "Apr.", "May.", "Jun.", "Jul.", "Aug.", "Sept.", "Oct.", "Nov.", "Dec."]
    static let ms_weekDay = ["周日","周一","周二","周三","周四","周五","周六"]

    public static func ms_dateFromDateComponents(components:DateComponents) -> Date?{
        return ms_localCalendar.date(from: components)
    }
    public static func ms_date(withDay day:Int? = 10,month:Int,year:Int) -> Date?{
        var comps = DateComponents()
        comps.year = year
        comps.month = month
        comps.day = day
        return ms_dateFromDateComponents(components: comps)
    }
    public static func ms_daysInMonth(month:Int,year:Int) -> Int?{
        guard let startDate = ms_date(month: month, year: year) else { return nil }
        guard let endDate = ms_date(month: month == 12 ? 1 :month + 1, year: month == 12 ? year + 1 : year) else {return nil
        }
             
        let diff = ms_localCalendar.dateComponents([.day], from: startDate, to: endDate)
            return diff.day
        
    }
    public static func ms_firstWeekdayInMonth(month:Int,year:Int)->Int{
        let date = ms_date(month: month, year: year)
        return ms_localCalendar.component(Calendar.Component.weekday, from: date!)
    }
    
    public static func ms_stringOfWeekdayInEnglish(weekDay:Int) -> String{
        assert(weekDay >= 1 && weekDay <= 7, "Invalid weekday")
        return ms_weekDayInEnglish[weekDay - 1]
    }
    public static func ms_stringOfMonthInEnglish(month:Int) -> String{
        assert(month >= 1 && month <= 12, "Invalid month")
        return ms_MonthInEnglish[month - 1]
    }
    public static func ms_dateComponentsFromDate(date:Date) -> DateComponents{
        return ms_localCalendar.dateComponents([.year,.month,.day], from: date)
    }
    public static func ms_isDateTodayWithDateComponents(components:DateComponents) -> Bool{
        let todayComps = ms_dateComponentsFromDate(date: Date(timeIntervalSinceNow: 0))
        return todayComps.year == components.year && todayComps.month == components.month && todayComps.day == components.day
    }
    public static func ms_isDateThisYear(date:Date) -> Bool{
        let todayComps = ms_dateComponentsFromDate(date: Date(timeIntervalSinceNow: 0))
        let comps = ms_dateComponentsFromDate(date: date)
        return comps.year == todayComps.year
    }
    public static func ms_weekdayStringFromDate(date:Date) -> String{
        return ms_weekDay[ms_weekdayIndexFromDate(date: date)]
    }
    public static func ms_weekdayIndexFromDate(date:Date) -> Int{
        let timeZone = TimeZone(identifier: "Asia/Shanghai")
        var calendar = ms_localCalendar
        calendar.timeZone = timeZone!
        let theComponents = calendar.component(Calendar.Component.weekday, from: date)
        return theComponents - 1
    }
    public static func ms_dateStringFromDate(date:Date) -> String{
        let formatter = ms_getFormatter()
        if ms_isDateThisYear(date: date) {
            formatter.dateFormat = "MM月dd日"
        }else{
            formatter.dateFormat = "yyyy年MM月dd日"
        }
        return formatter.string(from: date)
    }
    public static func ms_getFormatter() -> DateFormatter{
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "Asia/Shanghai")
        return formatter
    }
    public static func ms_getDates(_ start:Date,_ end:Date) -> [DateComponents]{
        var mStart = start
        var componentAarray = [DateComponents]()
        var result = mStart.compare(end)
        var comps:DateComponents
        while result != .orderedDescending {
            comps = ms_localCalendar.dateComponents([.year,.month,.day,.weekday], from: start)
            componentAarray.append(comps)
            comps.day = comps.day! + 1
            mStart = ms_localCalendar.date(from: comps)!
            result = mStart.compare(end)
        }
        return componentAarray
    }
    public static func ms_getDaysInMonth(_ month:Int,year:Int) -> [String]{
        let date = ms_date(month: month, year: year)
        let range = ms_localCalendar.range(of: Calendar.Component.day, in: Calendar.Component.month, for: date!)
        let dateCount = range?.count ?? 1
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM"
        let str = formatter.string(from: date!)
        var arr = [String]()
        for i in 1...dateCount {
            let sr = "\(str)-" + String(format: "%02d", i)
            arr.append(sr)
        }
        return arr
    }
    public static func ms_getTimestampFromDate(date:Date) -> String{
        return String(date.timeIntervalSince1970)
    }
    public static func ms_dateFromDateString(dateString:String,formatterString:String) -> Date?{
        let formatter = DateFormatter()
        formatter.dateFormat = formatterString
        return formatter.date(from: dateString)
    }
    public static func ms_holiday(date:Date) -> String?{
        if let lo = ms_lunarHoliday(date: date) {
            return lo
        }
        return ms_commonHoliday(calendarDay: ms_dateComponentsFromDate(date: date))
    }
    public static func ms_lunarHoliday(date:Date) -> String?{
        let localComp = ms_lonCalendar.dateComponents([.year,.month,.day], from: date)
        if localComp.month == 1 && localComp.day == 1 {
            return "春节"
        }else if localComp.month == 1 && localComp.day == 1 {
            return "元宵"
        }else if localComp.month == 1 && localComp.day == 1 {
            return "龙抬头"
        }else if localComp.month == 1 && localComp.day == 1 {
            return "端午"
        }else if localComp.month == 1 && localComp.day == 1 {
            return "七夕"
        }else if localComp.month == 1 && localComp.day == 1 {
            return "中秋"
        }else if localComp.month == 1 && localComp.day == 1 {
            return "重阳"
        }else if localComp.month == 1 && localComp.day == 1 {
            return "腊八"
        }else if localComp.month == 1 && localComp.day == 1 {
            return "小年"
        }else if localComp.month == 1 && localComp.day == 1 {
            return "除夕"
        }
        return nil
    }
    public static func ms_commonHoliday(calendarDay:DateComponents) -> String?{
        if (calendarDay.month == 1 &&
            calendarDay.day == 1){
            return "元旦"
            
            //2.14情人节
        }else if (calendarDay.month == 2 &&
                  calendarDay.day == 14){
            return "情人节"
            
            //3.8妇女节
        }else if (calendarDay.month == 3 &&
                  calendarDay.day == 8){
            return "妇女节"
            
            //5.1劳动节
        }else if (calendarDay.month == 5 &&
                  calendarDay.day == 1){
            return "劳动节"
            
            //6.1儿童节
        }else if (calendarDay.month == 6 &&
                  calendarDay.day == 1){
            return "儿童节"
            
            //8.1建军节
        }else if (calendarDay.month == 8 &&
                  calendarDay.day == 1){
            return "建军节"
            
            //9.10教师节
        }else if (calendarDay.month == 9 &&
                  calendarDay.day == 10){
            return "教师节"
            
            //10.1国庆节
        }else if (calendarDay.month == 10 &&
                  calendarDay.day == 1){
            return "国庆节"
            
            //11.1植树节
        }else if (calendarDay.month == 3 &&
                  calendarDay.day == 12){
            return "植树节"
            
            //11.11光棍节
        }else if (calendarDay.month == 11 &&
                  calendarDay.day == 11){
            return "11.11"
        }
        return nil;
    }
    
    public static func ms_weekIndexForYearFromDate(date:Date) -> Int{
        return ms_localCalendar.ordinality(of: Calendar.Component.weekday, in: Calendar.Component.year, for: date)!
    }
}
