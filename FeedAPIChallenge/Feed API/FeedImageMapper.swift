//
//  FeedImageMapper.swift
//  FeedAPIChallenge
//
//  Created by Luis Garcia on 8/27/21.
//  Copyright © 2021 Essential Developer Ltd. All rights reserved.
//

import Foundation

final class FeedImageMapper {
	private init() {}

	private struct Root: Decodable {
		let items: [Item]
		var feed: [FeedImage] {
			return items.map { $0.item }
		}
	}

	private struct Item: Decodable {
		let id: UUID
		let description: String?
		let location: String?
		let url: URL

		private enum CodingKeys: String, CodingKey {
			case id = "image_id"
			case description = "image_desc"
			case location = "image_loc"
			case url = "image_url"
		}

		var item: FeedImage {
			return FeedImage(id: id,
			                 description: description,
			                 location: location,
			                 url: url)
		}
	}

	static func map(_ data: Data, response: HTTPURLResponse) -> FeedLoader.Result {
		guard response.statusCode == 200,
		      let root = try? JSONDecoder().decode(Root.self, from: data) else {
			return .failure(RemoteFeedLoader.Error.invalidData)
		}

		return .success(root.feed)
	}
}
