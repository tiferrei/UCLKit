//
//  MasterViewController.swift
//  UCLKit
//
//  Created by Tiago Ferreira on 15/02/2018.
//  Copyright © 2018 Tiago Ferreira. All rights reserved.
//

import UIKit
import UCLKit
import Locksmith
import RequestKit
import LocalAuthentication

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    let localAuthenticationContext = LAContext()
    var config: TokenConfiguration?

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        if let split = splitViewController {
            let controllers = split.viewControllers
            if let navigationController = controllers.last as? UINavigationController,
                let topViewController = navigationController.topViewController as? DetailViewController {
                detailViewController = topViewController
            }
        }
    }

    func askForAuth() {
        // Ask the user to enter token.
        let alertController = UIAlertController(title: "Welcome!", message: "Please enter your token.", preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = "token"
        }
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { (_) in
            try! Locksmith.updateData(data: ["token": alertController.textFields![0].text!], forUserAccount: "UCLAPI User")
            self.config = TokenConfiguration(alertController.textFields![0].text)
        }
        alertController.addAction(confirmAction)
        self.present(alertController, animated: true, completion: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.config == nil {
            if let data = Locksmith.loadDataForUserAccount(userAccount: "UCLAPI User"), let token = data["token"] as? String {
                var authError: NSError?
                if localAuthenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) {
                    localAuthenticationContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Your device will now verify your biometrics to make sure only you have access to your token.") { success, error in
                        if success {
                            self.config = TokenConfiguration(token)
                        } else {
                            try! Locksmith.deleteDataForUserAccount(userAccount: "UCLAPI User")
                            self.askForAuth()
                        }
                    }
                } else if localAuthenticationContext.canEvaluatePolicy(.deviceOwnerAuthentication, error: &authError) {
                    localAuthenticationContext.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: "Your device will now verify your passcode to make sure only you have access to your token.") { success, error in
                        if success {
                            self.config = TokenConfiguration(token)
                        } else {
                            try! Locksmith.deleteDataForUserAccount(userAccount: "UCLAPI User")
                            self.askForAuth()
                        }
                    }
                }
            } else {
                askForAuth()
            }
        }
    }

    func requestParamsWithAlert(_ keys: String..., requestCompletion: @escaping (_ params: [String: String]) -> Void) {
        let alertController = UIAlertController(title: "More Info Needed", message: "Please enter required param(s).", preferredStyle: .alert)

        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { (_) in
            var params = [String: String]()
            for iterator in 0...keys.count - 1 {
                params[keys[iterator]] = alertController.textFields?[iterator].text
            }
            requestCompletion(params)
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }

        for key in keys {
            alertController.addTextField { (textField) in
                textField.placeholder = key
            }
        }

        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)

        self.present(alertController, animated: true)
    }

    func parse<T: Codable>(_ response: Response<T>, for view: DetailViewController, with config: TokenConfiguration, and params: [String: String] = [:]) {
        switch response {
        case .success(let responseData):
            view.request["HTTP STATUS"] = "200 OK"
            for param in params {
                view.request[param.key] = param.value
            }
            view.data = responseData.toDictionary()
        case .failure(let error as NSError):
            view.request["HTTP STATUS"] = "\(error.code)"
            view.data["OK"] = "false"
            view.data["error"] = UCLKit(config).parseError(error)
        }
    }

    @IBAction func didTouchSignOut(_ sender: Any) {
        try! Locksmith.deleteDataForUserAccount(userAccount: "UCLAPI User")
        askForAuth()
    }

    // MARK: - UIStoryboardSegue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let config = self.config, let navigationController = segue.destination as? UINavigationController,
        let detailViewController = navigationController.topViewController as? DetailViewController {
            detailViewController.refreshControl?.beginRefreshing()
            DispatchQueue.main.async {
                detailViewController.title = segue.identifier!
                switch segue.identifier! {
                case "GET Rooms":
                    let _ = UCLKit(config).rooms { rooms in
                        self.parse(rooms, for: detailViewController, with: config)
                    }
                case "GET Bookings":
                    let _ = UCLKit(config).bookings { bookings in
                        self.parse(bookings, for: detailViewController, with: config)
                    }
                case "GET Equipment":
                    self.requestParamsWithAlert("roomID", "siteID") { params in
                        let _ = UCLKit(config).equipment(roomID: params["roomID"]!, siteID: params["siteID"]!) { equipment in
                                self.parse(equipment, for: detailViewController, with: config, and: params)
                        }
                    }
                case "GET Free Rooms":
                    self.requestParamsWithAlert("start_datetime", "end_datetime") { params in
                        fatalError("Not implemented yet.")
                    }
                case "GET People":
                    self.requestParamsWithAlert("query") { params in
                        let _ = UCLKit(config).people(query: params["query"]!) { people in
                            self.parse(people, for: detailViewController, with: config, and: params)
                        }
                    }
                case "GET Personal Timetable":
                    self.requestParamsWithAlert("client_secret") { params in
                        fatalError("Not implemented yet.")
                    }
                case "GET Timetable By Modules":
                    self.requestParamsWithAlert("client_secret", "modules") { params in
                        fatalError("Not implemented yet.")
                    }
                case "GET Desktop Availability":
                    fatalError("Not implemented yet.")
                default:
                    fatalError("Unknown segue identifier received.")
                }
            }
        }
    }
}
