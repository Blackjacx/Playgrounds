import UIKit

let calendar = Calendar(identifier: .gregorian)
let formatter = DateFormatter()
formatter.calendar = calendar
formatter.formatterBehavior = .default
formatter.doesRelativeDateFormatting = false
formatter.timeStyle = .none
formatter.dateStyle = .none
formatter.locale = Locale(identifier: "en_US_POSIX")
formatter.timeZone = TimeZone(secondsFromGMT: 0)

let sDateNoMs = "2019-07-31T12:09:23Z"
let sDateWithMs = "2019-07-31T12:09:23.333Z"

let calendarComponent: Set<Calendar.Component> = [.hour, .minute, .second, .nanosecond]

formatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"
let dateNoMs = formatter.date(from: sDateNoMs)
let dateNoMsComponents = calendar.dateComponents(calendarComponent, from: dateNoMs!)

formatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSS'Z'"
let dateWithMs = formatter.date(from: sDateWithMs)
let dateWithMsComponents = calendar.dateComponents(calendarComponent, from: dateWithMs!)

