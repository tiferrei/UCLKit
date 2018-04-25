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

    // TODO: Implement title based on node selection and first property.
    // FIXME: Remove spacing when Request section is hidden.

    enum Sections: Int {
        case request
        case data
    }

    var request = [String: String]()
    var data = [String: Any]()

    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(DetailViewController.refresh), for: .valueChanged)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        refresh()
    }

    @IBAction func refresh() {
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
            let keys = Array(request.keys)
            let field = keys[indexPath.row]
            let value = request[field]

            cell.selectionStyle = .none
            cell.isUserInteractionEnabled = false

            cell.textLabel?.text = field
            cell.detailTextLabel?.text = value

            return cell
        case .data:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Data")!
            let keys = Array(data.keys)
            let field = keys[indexPath.row]
            cell.textLabel?.text = field
            if let value = data[field] as? String {
                cell.selectionStyle = .none
                cell.isUserInteractionEnabled = false

                cell.detailTextLabel?.text = value
            } else if let nodes = data[field] as? [String: Any] {
                tableView.allowsSelection = true
                cell.isUserInteractionEnabled = true
                cell.accessoryType = .disclosureIndicator

                cell.detailTextLabel?.text = "\(nodes.count) nodes"
            } else if let nodes = data[field] as? [Any] {
                tableView.allowsSelection = true
                cell.isUserInteractionEnabled = true
                cell.accessoryType = .disclosureIndicator

                cell.detailTextLabel?.text = "\(nodes.count) nodes"
            }
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
        switch Sections(rawValue: section)! {
        case .request:
            if request.isEmpty {
                return nil
            }
            return "Request"
        case .data:
            if data.isEmpty {
                return nil
            }
            return "Data"
        }
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch Sections(rawValue: section)! {
        case .request:
            if request.isEmpty {
                return CGFloat.leastNormalMagnitude
            } else {
                return UITableViewAutomaticDimension
            }
        case .data:
            return UITableViewAutomaticDimension
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nodeDetailViewController = segue.destination as? DetailViewController {
            let keys = Array(data.keys)
            let field = keys[tableView.indexPathForSelectedRow!.row]
            if let nodes = data[field] as? [Any] {
                var nodeData = [String: Any]()
                for (index, anyNode) in nodes.enumerated() {
                    if let node = anyNode as? [String: Any] {
                        nodeData["Node \(index)"] = node
                    }
                }
                nodeDetailViewController.data = nodeData
            } else if let nodes = data[field] as? [String: Any] {
                nodeDetailViewController.data = nodes
            }
        }
    }
}
