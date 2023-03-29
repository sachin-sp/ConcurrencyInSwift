import Foundation

public class TargetQueue {
    public init() {}
    
    public func test() {
        
        let a = DispatchQueue(label: "A")
        let b = DispatchQueue(label: "B", attributes: .concurrent, target: a)
        
        a.async {
            for i in 1...5 {
                print(i)
            }
        }
        a.async {
            for i in 6...10 {
                print(i)
            }
        }
        b.async {
            for i in 11...15 {
                print(i)
            }
        }
        b.async {
            for i in 16...20 {
                print(i)
            }
        }
    }
    
    public func test2() {
        
        let a = DispatchQueue(label: "A")
        let b = DispatchQueue(label: "B", attributes: [.concurrent, .initiallyInactive])
        b.setTarget(queue: a)
        
        a.async {
            for i in 1...5 {
                print(i)
            }
        }
        a.async {
            for i in 6...10 {
                print(i)
            }
        }
        b.async {
            for i in 11...15 {
                print(i)
            }
        }
        b.async {
            for i in 16...20 {
                print(i)
            }
        }
        b.activate()
    }
}
