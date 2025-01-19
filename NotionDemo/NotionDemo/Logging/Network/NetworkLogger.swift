import Foundation

class NetworkLogger {

    private let queue = DispatchQueue(
        label: "network-logger-thread-safe-obj",
        attributes: .concurrent
    )

    private var _logs: [NetworkLog] = []

    var logs: [NetworkLog] {
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

    func log(_ request: URLRequest, withID id: UUID) {
        guard logs.first(where: { $0.id == id} ) == nil else {
            return
        }
        logs.append(NetworkLog(id: id, request: request))
    }

    func log(_ response: URLResponse, data: Data, withID id: UUID) {
        guard let idx = logs.firstIndex(where: { $0.id == id} ) else {
            return
        }
        logs[idx].response = response
        logs[idx].data = data
    }

    func log(_ error: String, withID id: UUID) {
        guard let idx = logs.firstIndex(where: { $0.id == id} ) else {
            return
        }
        logs[idx].error = error
    }

    func clear() {
        logs = []
    }
}
