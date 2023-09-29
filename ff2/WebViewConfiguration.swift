//
//  WebViewConfiguration.swift
//  ff2
//
//  Created by Dave Elward on 9/28/23.
//

import Foundation

class WebViewConfiguration: Codable {
    var currentPage: String
    var currentScrollPosition: CGPoint
    var zoomMagnification:CGFloat

    init(currentPage: String, currentScrollPosition: CGPoint, zoomMagnification: CGFloat) {
        self.currentPage = currentPage
        self.currentScrollPosition = currentScrollPosition
        self.zoomMagnification = zoomMagnification
    }
    
    static func documentsDirectory() -> URL {
         let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
         let documentsDirectory = paths[0]
         return documentsDirectory
     }
     
     static func dataModelURL() -> URL {
         let docURL = documentsDirectory()
         return docURL.appendingPathComponent(ff2App.getDataFileName())
     }
    
    private enum CoderKeys: String, CodingKey {
        case currentPage
        case currentScrollPosition
        case zoomMagnification
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CoderKeys.self)
        try container.encode(currentPage, forKey: .currentPage)
        try container.encode(currentScrollPosition, forKey: .currentScrollPosition)
        try container.encode(zoomMagnification, forKey: .zoomMagnification)
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CoderKeys.self)
        currentPage = try values.decode(String.self, forKey: .currentPage)
        currentScrollPosition = try values.decode(CGPoint.self, forKey: .currentScrollPosition)
        zoomMagnification = try values.decode(CGFloat.self, forKey: .zoomMagnification)
    }

    func save() {
        print("Called WebViewConfiguration.save")
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(self) {
            do {
                // Save the 'Products' data file to the Documents directory.
                try encoded.write(to: WebViewConfiguration.dataModelURL())
            } catch {
                print("Couldn't write to save file: " + error.localizedDescription)
            }
        }
    }
}

