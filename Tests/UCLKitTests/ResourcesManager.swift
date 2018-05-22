//
//  ResourcesManager.swift
//  UCLKit
//
//  Created by Tiago Ferreira on 17/05/2018.
//  Copyright © 2018 Tiago Ferreira. All rights reserved.
//

import Foundation

enum ResourcesManager: String {
    case NoToken = """
    {
        "error": "No token provided.",
        "ok": false
    }
    """

    case Bookings = """
    {
        "ok": true,
        "bookings": [
            {
                "slotid": 998503,
                "end_time": "2016-09-02T18:00:00+00:00",
                "description": "split weeks to assist rooming 29.06",
                "roomname": "Torrington (1-19) 433",
                "siteid": "086",
                "contact": "Ms Leah Markwick",
                "weeknumber": 1,
                "roomid": "433",
                "start_time": "2016-09-02T09:00:00+00:00",
                "phone": "45699"
            }
        ],
        "next_page_exists": true,
        "page_token": "6hb14hXjRV",
        "count": 1197
    }
    """

    case FreeRooms = """
    {
        "ok": true,
        "free_rooms": [
            {
                "roomname": "Wilkins Building (Main Building) Portico",
                "roomid": "Z4",
                "siteid": "005",
                "sitename": "Main Building",
                "capacity": 50,
                "classification": "SS",
                "automated": "N",
                "location": {
                    "coordinates": {
                        "lat": "51.524699",
                        "lng": "-0.13366"
                    },
                    "address": [
                        "Gower Street",
                        "London",
                        "WC1E 6BT",
                        ""
                    ]
                }
            }
        ]
    }
    """

    case Rooms = """
    {
        "ok": true,
        "rooms": [
            {
                "roomname": "Wilkins Building (Main Building) Portico",
                "roomid": "Z4",
                "siteid": "005",
                "sitename": "Main Building",
                "capacity": 50,
                "classification": "SS",
                "automated": "N",
                "location": {
                    "coordinates": {
                        "lat": "51.524699",
                        "lng": "-0.13366"
                    },
                    "address": [
                        "Gower Street",
                        "London",
                        "WC1E 6BT",
                        ""
                    ]
                }
            }
        ]
    }
    """

    case InvalidToken = """
    {
        "error": "Token is invalid.",
        "ok": false
    }
    """

    case People = """
    {
        "ok": true,
        "people": [
            {
                "name": "Jane Doe",
                "status": "Student",
                "department": "Dept of Med Phys & Biomedical Eng",
                "email": "jane.doe.17@ucl.ac.uk"
            }
        ]
    }
    """

    case Equipment = """
    {
        "ok": true,
        "equipment": [
            {
                "type": "FF",
                "description": "Managed PC",
                "units": 1
            },
            {
                "type": "FE",
                "description": "Chairs with Tables",
                "units": 1
            }
        ]
    }
    """
}
