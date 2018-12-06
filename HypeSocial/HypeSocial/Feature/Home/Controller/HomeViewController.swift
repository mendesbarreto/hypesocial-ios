import UIKit
import MSAL

final class HomeViewController: UIViewController, UITextFieldDelegate, URLSessionDelegate {

    @IBOutlet private weak var loggingText: UITextView!
    @IBOutlet private weak var signoutButton: UIButton!

    private let tempServiceMSAL = TempServiceMSAL()
    private let tableView = UITableView()

    /**
        Setup public client application in viewDidLoad
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        tempServiceMSAL.start()

        view.addSubview(tableView)      
        tableView.anchorToFit(in: view)
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
        signoutButton.isEnabled = enabled
    }

    @IBAction func signoutButton(_ sender: UIButton) {
        tempServiceMSAL.signout()
    }
}

