import UIKit
import MSAL
import SnapKit

extension HomeViewController: TempServiceMSALDelegate {
    func onSignIn() {
        DispatchQueue.main.async { [weak self] in
            guard let navigationController = self?.navigationController else { return }

            let eventListViewController = UIStoryboard(name: "Main", bundle: nil)
                    .instantiateViewController(withIdentifier: String(describing: EventListViewController.self))
            navigationController.pushViewController(eventListViewController, animated: true)
        }
    }

    func onSignOut() {
    }

    func onError() {
    }
}


final class HomeViewController: UIViewController, UITextFieldDelegate, URLSessionDelegate {

    private let tempServiceMSAL = TempServiceMSAL()

    /**
        Setup public client application in viewDidLoad
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        tempServiceMSAL.delegate = self
        tempServiceMSAL.start()
        tempServiceMSAL.signout()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateSignoutButton(enabled: true)
    }

    @IBAction func callGraphButton(_ sender: UIButton) {
        if tempServiceMSAL.currentAccount() == nil {
            tempServiceMSAL.acquireTokenInteractively()
        } else {
            tempServiceMSAL.acquireTokenSilently()
        }
    }

    func updateSignoutButton(enabled: Bool) {
        //signoutButton.isEnabled = enabled
    }

    @IBAction func signoutButton(_ sender: UIButton) {
        tempServiceMSAL.signout()
    }
}

