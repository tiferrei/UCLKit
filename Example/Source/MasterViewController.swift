//
//  MasterViewController.swift
//  UCLKit Demo
//
//  Created by Tiago Ferreira on 15/02/2018.
//  Copyright © 2018 Tiago Ferreira. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    var objects = NSMutableArray()

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

    // MARK: - UIStoryboardSegue

    func requestParamsWithAlert(_ keys: String...) -> [String: String] {
        // Declare Alert object to get required params
        let alertController = UIAlertController(title: "More Info Needed", message: "Please enter required param(s).", preferredStyle: .alert)

        // Add a confirm action with inputs
        var params = [String: String]()
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { (_) in
            for iterator in 0...keys.count - 1 {
                params[keys[iterator]] = alertController.textFields?[iterator].text
            }
        }

        // Add a cancel option
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }

        // Add placeholders
        for key in keys {
            alertController.addTextField { (textField) in
                textField.placeholder = key
            }
        }

        // Add actions to Alert object
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)

        // Present the alert
        self.present(alertController, animated: true, completion: nil)
        return params
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let navigationController = segue.destination as? UINavigationController,
        let detailViewController = navigationController.topViewController as? DetailViewController {

            func requestForSegue(_ segue: UIStoryboardSegue) -> [String: String] {
                detailViewController.segueIdentifier = segue.identifier!
                switch segue.identifier! {
                case "EQUIPMENT":
                    return requestParamsWithAlert("roomid", "siteid")
                case "FREE ROOMS":
                    return requestParamsWithAlert("start_datetime", "end_datetime")
                case "PEOPLE":
                    return requestParamsWithAlert("query")
                case "PERSONAL TIMETABLE":
                    return requestParamsWithAlert("client_secret")
                case "TIMETABLE BY MODULES":
                    return requestParamsWithAlert("client_secret", "modules")
                default:
                    return [:]
                }
            }

            detailViewController.params = requestForSegue(segue)
        }
    }
}
