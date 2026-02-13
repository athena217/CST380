//
//  Task.swift
//  lab-task-squirrel
//
//  Created by Charlie Hieger on 11/15/22.
//

import UIKit
import CoreLocation

class Task {
    let title: String
    let description: String
    var image: UIImage?
    var imageLocation: CLLocation?
    var isComplete: Bool {
        image != nil
    }

    init(title: String, description: String) {
        self.title = title
        self.description = description
    }

    func set(_ image: UIImage, with location: CLLocation) {
        self.image = image
        self.imageLocation = location
    }
}

extension Task {
    static var mockedTasks: [Task] {
        return [
            Task(title: "Your Favorite Flowers 💐",
                 description: "Find a Flower That you Think is Beautiful!"),
            Task(title: "Your Favorite Hiking Spot 🦮",
                 description: "Take a Picture of the Trail or View!"),
            Task(title: "Your Favorite Waterfall 🌊",
                 description: "Show us a Waterfall you Visted!"),
            Task(title: "Your Favorite Sunset or Sunrise 🌅",
                 description: "Show us a Beautiful Sky you Captured!"),
            Task(title: "Your Favorite Outdoor Spot 🌁" ,
                 description: "Show us a Quiet Spot you Enjoy Visiting!")
        ]
    }
}
