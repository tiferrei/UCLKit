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
        case request, data
    }

    var config: TokenConfiguration?
    var params: [String: String] = [:]
    var request: [String: String] = [:]
    var data: [String: String] = [:]
    var segueIdentifier: String?

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
        if let segueIdentifier = self.segueIdentifier, let config = config {
            switch segueIdentifier {
            case "ROOMS":
                let _ = UCLKit(config).rooms { response in
                    switch response {
                    case .success(let responseData):
                        self.request["HTTP STATUS"] = "200 OK"
                        self.request["Results"] = "\(responseData.rooms!.count)"
                        for room in responseData.rooms! {
                            self.data[room.roomID!] = room.roomName!
                        }
                    case .failure(let error as NSError):
                        self.request["HTTP STATUS"] = "\(error.code)"
                        self.data["OK"] = "false"
                        self.data["error"] = UCLKit(config).parseError(error)
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
        case .request:
            return request.count
        case .data:
            return data.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch Sections(rawValue: (indexPath as NSIndexPath).section)! {
        case .request:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Request")!
            let field = request.keys.sorted(by: <)[indexPath.row]
            let value = request[field]

            cell.textLabel?.text = field
            cell.detailTextLabel?.text = value

            return cell
        case .data:
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
        case .request:
            return "Request"
        case .data:
            return "Data"
        }
    }
}
