//
//  Search.swift
//  UCLKit
//
//  Created by Tiago Ferreira on 24/11/2017.
//  Copyright © 2017 Tiago Ferreira. All rights reserved.
//

import Foundation
import RequestKit

// Mark: Model

/// Wrapper for the People response
@objc open class PeopleResponse: NSObject {
    open var OK: Bool?
    open var error: String?
    open var people: [Person]?

    public init(_ json: [String: Any]) {
        OK = json["ok"] as? Bool
        error = json["error"] as? String
        people = (json["people"] as? [[String: AnyObject]])?.map { Person($0) }
    }
}

/// Payload from the People response
@objc open class Person: NSObject {
    open var name: String?
    open var status: Status?
    open var department: String?
    open var email: String?

    public init(_ json: [String: Any]) {
        name = json["name"] as? String
        status = Status(rawValue: json["status"] as? String ?? "")
        department = json["department"] as? String
        email = json["email"] as? String
    }
}

/// Status enum to clarify options.
public enum Status: String {
    case Student = "Student"
    case Staff = "Staff"
    case Unknown = ""
}

// Mark: Requests

public extension UCLKit {
    /**
     Fetches matching people and information about them.
     - parameter query: Name of the person you are searching for.
     - parameter completion: Callback for the outcome of the fetch.
     */
    public func people(_ session: RequestKitURLSession = URLSession.shared, query: String, completion: @escaping (_ response: Response<PeopleResponse>) -> Void) -> URLSessionDataTaskProtocol? {
        let router = SearchRouter.searchPeople(configuration: configuration, query: query)
        return router.loadJSON(session, expectedResultType: [String: AnyObject].self) { json, error in
            if let error = error {
                completion(Response.failure(error))
            }

            if let json = json {
                let response = PeopleResponse(json)
                completion(Response.success(response))
            }
        }
    }
}

// MARK: Router

/**
 Main Search Router, contains:
 - GET People router
 */
enum SearchRouter: Router {
    case searchPeople(configuration: Configuration, query: String)

    var configuration: Configuration {
        switch self {
        case .searchPeople(let config, _): return config
        }
    }

    var method: HTTPMethod {
        return .GET
    }

    var encoding: HTTPEncoding {
        return .url
    }

    var params: [String: Any] {
        switch self {
        case .searchPeople(_, let query):
            return ["query": query]
        }
    }

    var path: String {
        switch self {
        case .searchPeople:
            return "search/people"
        }
    }
}
