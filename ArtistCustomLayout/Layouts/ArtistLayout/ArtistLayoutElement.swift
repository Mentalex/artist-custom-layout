//
//  ArtistLayoutElement.swift
//  ArtistCustomLayout
//
//  Created by Alex Tapia on 15/06/20.
//  Copyright © 2020 AlexTapia. All rights reserved.
//

import Foundation

/// kind of Elements used for `ArtistLayout`
enum ArtistLayoutElement: String {
  case cell
  case header
  case footer
  
  var id: String {
    return self.rawValue
  }
  
  var kind: String {
    return "Kind\(self.rawValue.capitalized)"
  }
}
