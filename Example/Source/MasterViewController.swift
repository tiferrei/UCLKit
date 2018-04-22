//
//  MasterViewController.swift
//  UCLKit Demo
//
//  Created by Tiago Ferreira on 15/02/2018.
//  Copyright © 2018 Tiago Ferreira. All rights reserved.
//

import UIKit
import UCLKit
import RequestKit

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
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

    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if self.config == nil {
            // Ask the user to enter token.
            let alertController = UIAlertController(title: "Welcome!", message: "Please enter your token.", preferredStyle: .alert)
            alertController.addTextField { (textField) in
                textField.placeholder = "token"
            }
            let confirmAction = UIAlertAction(title: "Confirm", style: .default) { (_) in
                self.config = TokenConfiguration(alertController.textFields![0].text)
            }
            alertController.addAction(confirmAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }

    // MARK: - UIStoryboardSegue
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let config = self.config, let navigationController = segue.destination as? UINavigationController,
        let detailViewController = navigationController.topViewController as? DetailViewController {
            detailViewController.refreshControl?.beginRefreshing()
            DispatchQueue.main.async {
                switch segue.identifier! {
                case "ROOMS":
                    let _ = UCLKit(config).rooms { rooms in
                        self.parse(rooms, for: detailViewController, with: config)
                    }
                case "BOOKINGS":
                    let _ = UCLKit(config).bookings { bookings in
                        self.parse(bookings, for: detailViewController, with: config)
                    }
                case "EQUIPMENT":
                    self.requestParamsWithAlert("roomID", "siteID") { params in
                        let _ = UCLKit(config).equipment(roomID: params["roomID"]!, siteID: params["siteID"]!) { equipment in
                                self.parse(equipment, for: detailViewController, with: config, and: params)
                        }
                    }
                case "FREE ROOMS":
                    self.requestParamsWithAlert("start_datetime", "end_datetime") { params in
                        // TODO: Free Rooms endpoint.
                        fatalError("Not implemented yet.")
                    }
                case "PEOPLE":
                    self.requestParamsWithAlert("query") { params in
                        let _ = UCLKit(config).people(query: params["query"]!) { people in
                            self.parse(people, for: detailViewController, with: config, and: params)
                        }
                    }
                case "PERSONAL TIMETABLE":
                    self.requestParamsWithAlert("client_secret") { params in
                        // TODO: Personal Timetable endpoint.
                        fatalError("Not implemented yet.")
                    }
                case "TIMETABLE BY MODULES":
                    self.requestParamsWithAlert("client_secret", "modules") { params in
                        // TODO: Timetable By Modules endpoint.
                        fatalError("Not implemented yet.")
                    }
                case "DESKTOP AVAILABILITY":
                    // TODO: Desktop Availability endpoint.
                    fatalError("Not implemented yet.")
                default:
                    fatalError("Unknown segue identifier received.")
                }
            }
        }
    }
}
