import UIKit

extension UIViewController {

    var topPresentedViewController: UIViewController {
        presentedViewController?.topPresentedViewController ?? self
    }
}
