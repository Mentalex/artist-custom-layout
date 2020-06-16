//
//  DataManager.swift
//  ArtistCustomLayout
//
//  Created by Alex Tapia on 14/06/20.
//  Copyright © 2020 AlexTapia. All rights reserved.
//

import Foundation

struct DataManager {
  
  static var sections: [Section] {
    let songs = Section(type: .grid, items: Array(0...5))
    let albums = Section(type: .list, items: Array(0...5))
    return [songs, albums]
  }
}
