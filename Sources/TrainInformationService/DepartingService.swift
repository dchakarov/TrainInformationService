//
//  DepartingService.swift
//  TrainInformationService
//

import Foundation

public struct DepartingService: Codable {
	public let serviceId: String
	public let destination: String
	public let departureTime: String
	public let currentStatus: String
	public let delayReason: String?
}
