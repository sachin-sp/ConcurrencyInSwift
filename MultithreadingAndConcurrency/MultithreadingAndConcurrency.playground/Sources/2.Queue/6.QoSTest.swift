import Foundation

public class QosTest {
    public init() {}
    public func test() {
        let userInteractiveQueue = DispatchQueue(label: "userInteractiveQueue", qos: .userInteractive)
        let userInitiatedQueue = DispatchQueue(label: "userInitiatedQueue", qos: .userInitiated)
        let utilityQueue = DispatchQueue(label: "utilityQueue", qos: .utility)
        let backgroundQueue = DispatchQueue(label: "backgroundQueue", qos: .background)
        
        // 4th Priority
        backgroundQueue.async {
            for i in 11...13 {
                print("\(i) Background Queue")
            }
        }
        
        // 3rd Priority
        utilityQueue.async {
            for i in 8...10 {
                print("\(i) Utility Queue")
            }
        }
        
        // 2nd Priority
        userInitiatedQueue.async {
            for i in 4...7 {
                print("\(i) UserInitiated Queue")
            }
        }
        
        // 1st Priority
        userInteractiveQueue.async {
            for i in 1...3 {
                print("\(i) UserInteractive Queue")
            }
        }
        
    }
}
