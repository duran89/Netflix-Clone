//
//  YoutubeSearchResponse.swift
//  Netflix Clone
//
//  Created by 권정근 on 3/8/24.
//

import Foundation


struct YoutubeSearchResponse: Codable {
    let items: [VideoElement]
}

struct VideoElement: Codable {
    let id: IdVideoElement
}

struct IdVideoElement: Codable {
    let kind: String
    let videoId: String
}


