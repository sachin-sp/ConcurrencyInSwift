import Foundation

/*
 
 Operation - An abstract class that represents the code and data associated with a single task
 Notes: Swift does not support abstract class
 
 Operation Properties
 - isReady: Bool { get }
 - isExecuting: Bool { get }
 - isCancelled: Bool { get }
 - isFinished: Bool { get }
 
 Operation
  - OperationQueue
  - Block Operation
  - NSInvocationOperation (Only in Objective-C)
 
 Operations are synchrounous
 Block Operation concurrent and synchronous
 
 */

public class OperationTest {
    
    public init() {}
    
    public func test() {
        print("About to start operation")
        testOpetation()
        print("Operation executed")
    }
    
    private func testOpetation() {
        let operation: BlockOperation = BlockOperation()
        
        operation.completionBlock = {
            print("Did finish all operation blocks")
        }
        
        operation.addExecutionBlock {
            print("First block executed")
        }
        operation.addExecutionBlock {
            print("Second block executed")
        }
        operation.addExecutionBlock {
            print("Third block executed")
        }
        DispatchQueue.global().async{
            operation.start()
            print("Did this execute on main thread - \(Thread.isMainThread)")
        }
    }
    
    public func testCustomOperation() {
        let operation: CustomOperation = CustomOperation()
        operation.start()
        print("Custome operation executed")
    }
    
    //To execute block operation in back ground thread create operation queue and add operations to that queue
    public func testOperationQueue() {
        let operationQueue: OperationQueue = OperationQueue()
        
        let operation1: BlockOperation = BlockOperation()
        operation1.addExecutionBlock {
            print("operation1 block is being executed")
        }
        operation1.completionBlock = {
            print("operation1 block executed")
        }
        operationQueue.addOperation(operation1)
    }
    
    public func testMultiBlockOperationWithOperationQueue() {
        let operationQueue: OperationQueue = OperationQueue()
        let operation1: BlockOperation = BlockOperation()
        operation1.addExecutionBlock {
            print("operation1 block is being executed")
            for i in 1...5 {
                sleep(1)
                print(i)
            }
        }
        
        operation1.completionBlock = {
            print("operation1 block executed")
        }
        
        let operation2: BlockOperation = BlockOperation()
        operation2.addExecutionBlock {
            print("operation2 block is being executed")
            for i in 6...10 {
                print(i)
            }
        }
        
        operation2.completionBlock = {
            print("operation2 block executed")
        }
        
        operationQueue.addOperation(operation1)
        operationQueue.addOperation(operation2)
    }
    
    //To make serial execution set maxConcurrentOperationCount to 1
    public func testSerialMultiBlockOperationWithOperationQueue() {
        let operationQueue: OperationQueue = OperationQueue()
        //To make serial execution set maxConcurrentOperationCount to 1
        operationQueue.maxConcurrentOperationCount = 1
        let operation1: BlockOperation = BlockOperation()
        operation1.addExecutionBlock {
            print("operation1 block is being executed")
            for i in 1...5 {
                sleep(1)
                print(i)
            }
        }
        
        operation1.completionBlock = {
            print("operation1 block executed")
        }
        
        let operation2: BlockOperation = BlockOperation()
        operation2.addExecutionBlock {
            print("operation2 block is being executed")
            for i in 6...10 {
                print(i)
            }
        }
        
        operation2.completionBlock = {
            print("operation2 block executed")
        }
        
        operationQueue.addOperation(operation1)
        operationQueue.addOperation(operation2)
    }
    
    //Another way to make operation queue serial is adding dependency
    //Slight delay in compeltion block
    public func testDependency() {
        let operationQueue: OperationQueue = OperationQueue()
        let operation1: BlockOperation = BlockOperation()
        operation1.addExecutionBlock {
            print("operation1 block is being executed")
            for i in 1...5 {
                sleep(1)
                print(i)
            }
        }
        
        operation1.completionBlock = {
            print("operation1 block executed")
        }
        
        let operation2: BlockOperation = BlockOperation()
        operation2.addExecutionBlock {
            print("operation2 block is being executed")
            for i in 6...10 {
                print(i)
            }
        }
        
        operation2.completionBlock = {
            print("operation2 block executed")
        }
        operation2.addDependency(operation1)
        operationQueue.addOperation(operation1)
        operationQueue.addOperation(operation2)
    }
    
    // Depency fails when block operation executed in async queue
    public func testDependecyFail() {
        let operationQueue: OperationQueue = OperationQueue()
        let operation1: BlockOperation = BlockOperation(block: printNumbers1)
        let operation2: BlockOperation = BlockOperation(block: printNumbers2)
        
        operation2.addDependency(operation1)
        operationQueue.addOperation(operation1)
        operationQueue.addOperation(operation2)
    }
    
    private func printNumbers1() {
        DispatchQueue.global().async {
            for i in 1...10 {
                print(i)
            }
        }
        
    }
    
    private func printNumbers2() {
        DispatchQueue.global().async {
            for i in 11...20 {
                print(i)
            }
        }
    }
    //***********************
    
    //To Overcome failed dependency, create custom AsyncOperation class and handel state of the operation
    public func testCustomAsyncOperation() {
        let operationQueue: OperationQueue = OperationQueue()
        let operation1: PrintNumbersOperation = PrintNumbersOperation(range: Range(1 ... 10))
        let operation2: PrintNumbersOperation = PrintNumbersOperation(range: Range(11 ... 20))
        
        operation2.addDependency(operation1)
        operationQueue.addOperation(operation1)
        operationQueue.addOperation(operation2)
    }
    
}

class CustomOperation: Operation {
    
    // Bad practice to create/init Thread
    // Taking it off main thread
    // Instead use OperationQueue to take off main thread
    override func start() {
        Thread.init(block: main).start()
    }
    
    override func main() {
        for i in 1...5 {
            print(i)
        }
    }
}

class AsyncOperation: Operation {
    enum State: String {
        case isReady
        case isExecuting
        case isFinished
    }
    
    var state: State = .isReady {
        willSet(newValue) {
            willChangeValue(forKey: state.rawValue)
            willChangeValue(forKey: newValue.rawValue)
        }
        didSet {
            didChangeValue(forKey: oldValue.rawValue)
            didChangeValue(forKey: state.rawValue)
        }
    }
    
    override var isAsynchronous: Bool { true }
    override var isExecuting: Bool { state == .isExecuting }
    override var isFinished: Bool {
        if isCancelled && state != .isExecuting { return true }
        return state == .isFinished
    }
    
    override func start() {
        guard !isCancelled else {
            state = .isFinished
            return
        }
        state = .isExecuting
        main()
    }
    
    override func cancel() {
        state = .isFinished
    }
}

class PrintNumbersOperation: AsyncOperation {
    var range: Range<Int>
    
    init(range: Range<Int>) {
        self.range = range
    }
    
    override func main() {
        DispatchQueue.global().async { [weak self] in
            guard let self : PrintNumbersOperation = self else { return }
            for i in self.range {
                print(i)
            }
            self.state = .isFinished
        }
    }
}
