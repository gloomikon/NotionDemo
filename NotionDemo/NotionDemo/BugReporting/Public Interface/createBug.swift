import SwiftUI

func createBug(
    @BugInfoResultBuilder infos: () -> [BugInfo]
) {
    guard let topPresentedViewController = UIApplication.keyWindow?.rootViewController?.topPresentedViewController else {
        return
    }

    let viewModel = BugReportingViewModel(infos: infos())
    let view = BugReportingView(viewModel: viewModel)
    let viewController = UIHostingController(rootView: view)
    topPresentedViewController.present(viewController, animated: true)
}
