import Foundation

public class DispatchWorkItemTest {
    public init() {}
    
    var count = 0
    var dispatchWorkItem: DispatchWorkItem?
    
    public func test() {
        callEveryOneSecond()
    }
    
    private func callEveryOneSecond() {
        count += 1
        if count < 5 {
            execute()
        }
    }
    
    private func execute() {
        dispatchWorkItem?.cancel()
        let workItem = DispatchWorkItem {
            for i in 1...5 {
                print("Dispatch Work Item \(i)")
            }
        }
        dispatchWorkItem = workItem
        DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(1), execute: workItem)
    }
}
