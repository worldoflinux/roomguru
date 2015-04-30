//
//  CalendarEntry.swift
//  Roomguru
//
//  Created by Radoslaw Szeja on 01/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

class CalendarEntry: NSObject, NSSecureCoding {
    
    var calendarID: String = ""
    var event = Event()
    
    init(calendarID: String, event: Event) {
        self.calendarID = calendarID
        self.event = event
        super.init()
    }
    
    class func caledarEntries(calendarID: String, events: [Event]) -> [CalendarEntry] {
        return events.map { CalendarEntry(calendarID: calendarID, event: $0) }
    }
    
    // MARK: NSSecureCoding
    
    required init(coder aDecoder: NSCoder) {
        if let calendarID = aDecoder.decodeObjectForKey("calendarID") as? String {
            self.calendarID = calendarID
        }
        
        if let event = aDecoder.decodeObjectOfClass(Event.self, forKey: "event") as? Event {
            self.event = event
        }
        
        super.init()
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.calendarID, forKey: "calendarID")
        aCoder.encodeObject(self.event, forKey: "event")
    }
    
    class func supportsSecureCoding() -> Bool {
        return true
    }
}

extension CalendarEntry {
    
    class func sortedByDate(items: [CalendarEntry]) -> [CalendarEntry] {
        return items.sorted {
            if let firstDate = $0.event.start, secondDate = $1.event.start {
                return firstDate.compare(secondDate).ascending
            }
            return false
        }
    }
}

extension CalendarEntry {
    
    /**
    *   This method expects *sorted by date* array of Events
    */
    class func entriesWithFreeGaps(var entries: [CalendarEntry]) -> [CalendarEntry] {
        
        var freeEntries: [CalendarEntry] = []
        let eventsCount = entries.count
        let today = NSDate()
        let minimumPeriod = 30*60.0
        
        for (index: Int, entry: CalendarEntry) in enumerate(entries) {
            let nextIndex = index + 1
            if nextIndex < eventsCount {
                let nextEntry = entries[index+1]
                
                if let nextEventStart = nextEntry.event.startDate?.date() {
                    if let eventEnd = entry.event.endDate?.date() {
                        
                        if !contains(freeEntries, entry) {
                            freeEntries.append(entry)
                        }

                        if eventEnd.day == nextEventStart.day && nextEventStart.day >= today.day && nextEventStart >= today {
                            let timePeriod = nextEventStart.timeIntervalSinceDate(eventEnd)
                            
                            
                            var slotsCount = Int(floor(timePeriod / minimumPeriod))
                            println("Free slots: \(slotsCount)")
                            var nextStartDay = eventEnd
                            
                            
                            while (slotsCount > 0) {
                                --slotsCount
                                let freeEvent = FreeEvent(startDate: nextStartDay, endDate: nextStartDay.dateByAddingTimeInterval(minimumPeriod))
                                let freeEntry = CalendarEntry(calendarID: entry.calendarID, event: freeEvent)
                                freeEntries.append(freeEntry)
                                nextStartDay = nextStartDay.dateByAddingTimeInterval(minimumPeriod)
                            }
                        }
                        
                        if !contains(freeEntries, nextEntry) {
                            freeEntries.append(nextEntry)
                        }
                    }
                }
            }
        }
        
        return freeEntries
    }
}

