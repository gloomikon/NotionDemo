import Foundation

class SimpleLogger {

    private let queue = DispatchQueue(
        label: "simple-logger-thread-safe-obj",
        attributes: .concurrent
    )

    private var _logs: [SimpleLog] = []

    var logs: [SimpleLog] {
        get {
            queue.sync { [unowned self] in
                _logs
            }
        }
        set {
            queue.async(flags: .barrier) { [unowned self] in
                _logs = newValue
            }
        }
    }

    func log(_ text: String) {
        logs.append(SimpleLog(text))
    }

    func clear() {
        logs = []
    }
}
