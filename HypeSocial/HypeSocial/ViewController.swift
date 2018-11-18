import UIKit
import MSAL

struct Application {
    static let clientID = "16c34857-fd53-447b-846a-fee84c368aaa"
    static let graphURI = "https://graph.microsoft.com/v1.0/me/"
    static let scopes: [String] = ["https://graph.microsoft.com/user.read", "https://graph.microsoft.com/contacts.read"]
    static let authority = "https://login.microsoftonline.com/common"
}

final class ViewController: UIViewController, UITextFieldDelegate, URLSessionDelegate {

    private var accessToken: String = ""
    private var idToken: String = ""
    private var applicationContext : MSALPublicClientApplication?

    @IBOutlet private weak var loggingText: UITextView!
    @IBOutlet private weak var signoutButton: UIButton!

    /**
        Setup public client application in viewDidLoad
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            UIView.animate(withDuration: <#T##TimeInterval##Foundation.TimeInterval#>, animations: <#T##@escaping () -> Void##@escaping () -> Swift.Void#>)
            guard let authorityURL = URL(string: Application.authority) else {
                updateLogging(text: "Unable to create authority URL")
                return
            }

            let authority = try MSALAuthority(url: authorityURL)
            applicationContext = try MSALPublicClientApplication(clientId: Application.clientID, authority: authority)

        } catch let error {
            updateLogging(text: "Unable to create Application Context \(error)")
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateSignoutButton(enabled: !accessToken.isEmpty)
    }

    @IBAction func callGraphButton(_ sender: UIButton) {
        if currentAccount() == nil {
            acquireTokenInteractively()
        } else {
            acquireTokenSilently()
        }
    }

    func acquireTokenInteractively() {
        guard let applicationContext = applicationContext else {
            updateLogging(text: "Applciation context not exists")
            return
        }

        applicationContext.acquireToken(forScopes: Application.scopes) { [weak self] (result, error) in
            guard let strongSelf = self else { return }

            if let error = error {
                print(error as NSError)
                strongSelf.updateLogging(text: "Could not acquire token: \(error)")
                return
            }

            guard let result = result else {
                strongSelf.updateLogging(text: "Could not acquire token: No result returned")
                return
            }

            print(result.accessToken!)
            strongSelf.accessToken = result.accessToken!
            strongSelf.updateLogging(text: "Access token is \(strongSelf.accessToken)")
            strongSelf.updateSignoutButton(enabled: true)
            strongSelf.getContentWithToken()
        }
    }

    func updateSignoutButton(enabled: Bool) {
        signoutButton.isEnabled = enabled
    }

    func updateLogging(text: String) {
        loggingText.text += "\(text)\n"
        print("\(text)\n")
    }

    func acquireTokenSilently() {
        guard let applicationContext = self.applicationContext else { return }
        applicationContext.acquireTokenSilent(forScopes: Application.scopes, account: currentAccount()) { [weak self] (result, error) in
            guard let strongSelf = self else { return }

            if let error = error {
                let nsError = error as NSError
                if (nsError.domain == MSALErrorDomain
                        && nsError.code == MSALErrorCode.interactionRequired.rawValue) {

                    DispatchQueue.main.async {
                        strongSelf.acquireTokenInteractively()
                    }
                } else {
                    DispatchQueue.main.async {
                        strongSelf.updateLogging(text: "Could not acquire token silently: \(error)")
                    }
                }

                return
            }

            guard let result = result else {
                DispatchQueue.main.async {
                    strongSelf.updateLogging(text: "Could not acquire token: No result returned")
                }
                return
            }

            DispatchQueue.main.async {
                strongSelf.idToken = result.idToken
                strongSelf.accessToken = result.accessToken!
                strongSelf.updateLogging(text: "Refreshed Access token is \(strongSelf.accessToken)")
                strongSelf.updateSignoutButton(enabled: true)
                strongSelf.getContentWithToken()
                strongSelf.updateLogging(text: "\n\n \(strongSelf.idToken)")
            }
        }
    }

    func currentAccount() -> MSALAccount? {
        guard let applicationContext = self.applicationContext else { return nil }

        do {
            let cachedAccounts = try applicationContext.allAccounts()

            if !cachedAccounts.isEmpty {
                return cachedAccounts.first
            }

        } catch let error as NSError {
            updateLogging(text: "Didn't find any accounts in cache: \(error)")
        }

        return nil
    }

    func getContentWithToken() {
        let url = URL(string: Application.graphURI)
        print("Bearer \(self.accessToken)")
        var request = URLRequest(url: url!)
        request.setValue("Bearer \(self.accessToken)", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let strongSelf = self else { return }

            if let error = error {
                strongSelf.updateLogging(text: "Couldn't get graph result: \(error)")
                return
            }

            guard let result = try? JSONSerialization.jsonObject(with: data!, options: []) else {

                strongSelf.updateLogging(text: "Couldn't deserialize result JSON")
                return
            }

            strongSelf.updateLogging(text: "Result from Graph: \(result))")

        }.resume()
    }

    @IBAction func signoutButton(_ sender: UIButton) {
        guard let applicationContext = self.applicationContext else { return }
        guard let account = self.currentAccount() else { return }
        
        do {
            try applicationContext.remove(account)
            loggingText.text = ""
            updateSignoutButton(enabled: false)
        } catch {
            self.updateLogging(text: "Received error signing account out: \(error)")
        }
    }
}
