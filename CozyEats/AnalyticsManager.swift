import Foundation
import FirebaseAnalytics

//Manager to handle app analytics
final class AnalyticsManager {
    private init() {}
    
    static let shared = AnalyticsManager()
    
    public func log(_ event: AnalyticsEvent) {
        var parameters: [String: Any] = [:]
        
        switch event {
        case .menuSelected(let rmMenuSelectedEvent):
            do {
                let data = try JSONEncoder().encode(rmMenuSelectedEvent)
                let dict = try JSONSerialization.jsonObject(with: data) as? [String: Any] ?? [:]
                parameters = dict
            } catch {
                
            }
        }
        
        print("\n Event: \(event.eventName) | Params: \(parameters)")
        
        Analytics.logEvent(event.eventName, parameters: ["menu": "Jackie"])
    }
}

enum AnalyticsEvent {
    case menuSelected(rmMenuSelectedEvent)
    
    var eventName:String {
        switch self {
        case .menuSelected: return "menu_selected"
        }
    }
}

struct rmMenuSelectedEvent: Codable {
    let menuName: String
    let origin: String
    let timestamp: Date
}
