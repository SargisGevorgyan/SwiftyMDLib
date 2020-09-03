//
//  Date+Utilities.swift
//
//  Copyright © 2019 MagicDevs. All rights reserved.
//


public extension Date {

    static let D_MINUTE = 60
    static let D_HOUR = 3600
    static let D_DAY = 86400
    static let D_WEEK = 604800
    static let D_MONTH = 31556926/12
    static let D_YEAR = 31556926
    static let componentFlags: Set<Calendar.Component> = [.year, .month, .day, .weekOfYear, .weekOfMonth, .hour, .minute, .second, .weekday, .weekdayOrdinal]

    
    func isSameDayAsDate(_ aDate:Date) ->Bool {
        let calendar = Calendar.current
        let components1 = calendar.dateComponents([.day,.month,.year], from: aDate)
        let components2 = calendar.dateComponents([.day,.month,.year], from: self)
        
        return ((components1.day == components2.day) && (components1.month == components2.month) &&
        (components1.year == components2.year))
    }
    
    func daysAfterDate(_ aDate:Date) ->Int {
        let ti = self.timeIntervalSince(aDate)
        return Int(ti/Double(Date.D_DAY))
    }
    
    func daysBeforeDate(_ aDate:Date) ->Int {
        let ti = aDate.timeIntervalSince(self)
        return Int(ti/Double(Date.D_DAY))
    }
    
    func monthsAfterDate(_ aDate:Date) ->Int {
        let ti = self.timeIntervalSince(aDate)
        return Int(ti/Double(Date.D_MONTH))
    }
    
    func monthsBeforeDate(_ aDate:Date) ->Int {
        let ti = aDate.timeIntervalSince(self)
        return Int(ti/Double(Date.D_MONTH))
    }
    
    func yearsAfterDate(_ aDate:Date) ->Int {
        let ti = self.timeIntervalSince(aDate)
        return Int(ti/Double(Date.D_YEAR))
    }
    
    func yearsBeforeDate(_ aDate:Date) ->Int {
        let ti = aDate.timeIntervalSince(self)
        return Int(ti/Double(Date.D_YEAR))
    }
    
    func distanceInDaysToDate(_ aDate:Date) ->Int {
        let gregorianCalendar = Calendar.init(identifier: .gregorian)
        return gregorianCalendar.component(.day, from: aDate)
    }
    
    func changeMonth(_ month: Int) ->Date {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.day,.month,.year], from: self)
        components.month = month
        return calendar.date(from: components) ?? self
    }
    
    func changeDay(_ day: Int) ->Date {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.day,.month,.year], from: self)
        components.day = day
        return calendar.date(from: components) ?? self
    }
    
    func changeHour(_ hour: Int) ->Date {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.hour, .day,.month,.year], from: self)
        components.hour = hour
        return calendar.date(from: components) ?? self
    }
    
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }

    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay)!
    }
    
    func beginingOfMonthOfDate() ->Date {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.second, .minute, .hour, .day,.month,.year], from: self)
        components.day = 1
        components.hour = 0
        components.minute = 0
        components.second = 0
        return calendar.date(from: components) ?? self
    }
    
    func endOfMonthOfDate() ->Date {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.second, .minute, .hour, .day,.month,.year], from: self)
        components.month! += 1
        components.day = 0
        components.hour = 23
        components.minute = 59
        components.second = 59
        return calendar.date(from: components) ?? self
    }
    
    func addingDays(_ day: Int) ->Date {
        var components = DateComponents()
        components.day = day
        
        let calendar = Calendar.current
        return calendar.date(byAdding: components, to: self) ?? self
    }
    
    func subtractingDays(_ day: Int) ->Date {
        return addingDays(-day)
    }
    
    func addingHours(_ hours: Int) ->Date {
        let timeInterval = self.timeIntervalSince1970 + Double(Date.D_HOUR * hours)
        return Date(timeIntervalSince1970: timeInterval)
    }
    
    func subtractingHours(_ hours: Int) ->Date {
        return addingHours(-hours)
    }
    
    func addingMinutes(_ minutes: Int) ->Date {
        let timeInterval = self.timeIntervalSince1970 + Double(Date.D_MINUTE * minutes)
        return Date(timeIntervalSince1970: timeInterval)
    }
    
    func subtractingMinutes(_ minutes: Int) ->Date {
        return addingMinutes(-minutes)
    }
    
    func addingWeeks(_ week: Int) ->Date {
        var components = DateComponents()
        components.day = week*7
        
        let calendar = Calendar.current
        return calendar.date(byAdding: components, to: self) ?? self
    }
    
    func subtractingWeeks(_ week: Int) ->Date {
        return addingDays(-week*7)
    }
    
    func addingMonths(_ month: Int) ->Date {
        var components = DateComponents()
        components.month = month
        
        let calendar = Calendar.current
        return calendar.date(byAdding: components, to: self) ?? self
    }
    
    func subtractingMonths(_ month: Int) ->Date {
        
        return addingMonths(-month)
    }
    
    func addingYears(_ year: Int) ->Date {
        var components = DateComponents()
        components.year = year
        
        let calendar = Calendar.current
        return calendar.date(byAdding: components, to: self) ?? self
    }
    
    func subtractingYears(_ year: Int) ->Date {
        
        return addingYears(-year)
    }
    
    func isEqualToDateIgnoringTime(_ aDate: Date) ->Bool {
        
        let calendar = Calendar.current
        let components1 = calendar.dateComponents(Date.componentFlags, from: aDate)
        let components2 = calendar.dateComponents(Date.componentFlags, from: self)
        
        return ((components1.year == components2.year) &&
                (components1.month == components2.month) &&
                (components1.day == components2.day))
    }
    
    func isLaterThanDate(_ aDate: Date) ->Bool {
        return compare(aDate) == .orderedDescending
    }
    
    func isEarlierThanDate(_ aDate: Date) ->Bool {
        return compare(aDate) == .orderedAscending
    }
    func isToday() ->Bool {
        
        return isEqualToDateIgnoringTime(Date())
    }
    
    func isInFuture() -> Bool {
        return isLaterThanDate(Date())
    }
    
    func isInPast() ->Bool {
        return isEarlierThanDate(Date())
    }
}

public extension Date {

    func years(sinceDate: Date) -> Int? {
        return Calendar.current.dateComponents([.year], from: sinceDate, to: self).year
    }

    func months(sinceDate: Date) -> Int? {
        return Calendar.current.dateComponents([.month], from: sinceDate, to: self).month
    }

    func days(sinceDate: Date) -> Int? {
        return Calendar.current.dateComponents([.day], from: sinceDate, to: self).day
    }

    func hours(sinceDate: Date) -> Int? {
        return Calendar.current.dateComponents([.hour], from: sinceDate, to: self).hour
    }

    func minutes(sinceDate: Date) -> Int? {
        return Calendar.current.dateComponents([.minute], from: sinceDate, to: self).minute
    }

    func seconds(sinceDate: Date) -> Int? {
        return Calendar.current.dateComponents([.second], from: sinceDate, to: self).second
    }

}
