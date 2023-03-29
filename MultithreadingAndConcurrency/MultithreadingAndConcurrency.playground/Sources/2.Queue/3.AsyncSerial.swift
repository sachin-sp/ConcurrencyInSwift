import Foundation


public class AsyncSerial {
    public init() {}
    
    public func test() {
        let serialQueue = DispatchQueue(label: "serialQueue", qos: .background, autoreleaseFrequency: .never, target: nil)
        
        serialQueue.async {
            for i in 1...3 {
                sleep(1)
                print("\(i) Task 1")
            }
        }
        serialQueue.async {
            for i in 4...7 {
                print("\(i) Task 2")
            }
        }
        serialQueue.async {
            for i in 8...10 {
                print("\(i) Task 3")
            }
        }
    }
}
