import UIKit
import MSAL
import SnapKit
import SafariServices

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

    func signoutCurrentAccount() {
        let urlString = "https://login.microsoftonline.com/common/oauth2/v2.0/logout"
        var logoutUrl = URL(string: urlString)!
        var components = URLComponents(url: logoutUrl, resolvingAgainstBaseURL: false)!
        var queryItem = URLQueryItem(name: "post_logout_redirect_uri", value: "http://bitwise.ltda/")

        components.queryItems = [queryItem]

        let safariViewController = SFSafariViewController(url: components.url!)

        self.present(safariViewController, animated: true)
    }
    
    @IBAction func logoutAction(_ sender: UIButton) {
        signoutCurrentAccount()
        tempServiceMSAL.signout()
    }
}

