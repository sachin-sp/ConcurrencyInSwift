import Foundation

public class SyncConcurrent {
    public init() {}
    
    public func test() {
        let concurrentQueue = DispatchQueue(label: "concurrentQueue", qos: .background, attributes: .concurrent, autoreleaseFrequency: .never, target: nil)
        
        concurrentQueue.sync {
            for i in 1...3 {
                print("\(i) Task 1")
                sleep(1)
            }
        }
        concurrentQueue.sync {
            for i in 4...7 {
                print("\(i) Task 2")
            }
        }
        concurrentQueue.sync {
            for i in 8...10 {
                print("\(i) Task 3")
            }
        }
    }
}
