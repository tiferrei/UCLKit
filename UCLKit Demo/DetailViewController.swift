//
//  DetailViewController.swift
//  UCLKit Demo
//
//  Created by Tiago Ferreira on 15/02/2018.
//  Copyright © 2018 Tiago Ferreira. All rights reserved.
//

import UIKit
import UCLKit

class DetailViewController: UITableViewController {
    enum Sections: Int {
        case Request, Data
    }

    var request: [String: String] = [:]
    var data: [String: String] = [:]
    var segueIdentifier: String?

    // MARK: View Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        refreshControl?.addTarget(self, action: #selector(DetailViewController.refresh), for: .valueChanged)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        refresh()
    }

    // MARK: IBActions

    @IBAction func refresh() {
        refreshControl?.beginRefreshing()
        data.removeAll()
        let config = TokenConfiguration("uclapi-82a6442136f95a5-20d5ae3e0620b03-1a2983e54e33312-1c37b049e34fbfe")
        if let segueIdentifier = self.segueIdentifier {
            switch segueIdentifier {
            case "ROOMS":
                let _ = UCLKit(config).rooms() { response in
                    switch response {
                    case .success(let responseData):
                        self.request["STATUS"] = "200 OK"
                        self.data["OK"] = "\(responseData.OK ?? false)"
                    case .failure(let error as NSError):
                        self.request["STATUS"] = "\(error.code)"
                        self.data ["OK"] = "false"
                    }
                }
            default:
                break
            }
        }

        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
    }
}

// MARK: - UITableViewDataSource

extension DetailViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch Sections(rawValue: section)! {
        case .Request:
            return request.count
        case .Data:
            return data.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch Sections(rawValue: (indexPath as NSIndexPath).section)! {
        case .Request:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Request")!
            let field = request.keys.sorted(by: <)[indexPath.row]
            let value = request[field]

            cell.textLabel?.text = field
            cell.detailTextLabel?.text = value

            return cell
        case .Data:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Data")!
            let field = data.keys.sorted(by: <)[indexPath.row]
            let value = data[field]
            
            cell.textLabel?.text = field
            cell.detailTextLabel?.text = value

            return cell
        }
    }
}

// MARK: - UITableViewDelegate

extension DetailViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if self.tableView(tableView, numberOfRowsInSection: section) == 0 {
            return ""
        }

        switch Sections(rawValue: section)! {
        case .Request:
            return "Request"
        case .Data:
            return "Data"
        }
    }
    
    //TODO: Check if this actually does something or if it is dead code
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return tableView.rowHeight
//    }
}
