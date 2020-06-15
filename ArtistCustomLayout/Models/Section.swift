//
//  Section.swift
//  ArtistCustomLayout
//
//  Created by Alex Tapia on 15/06/20.
//  Copyright © 2020 AlexTapia. All rights reserved.
//

import Foundation

struct Section {
  var layout: LayoutType = .grid
  var header: String?
  var footer: String?
  var items: [Int]
}
