//
//  DepartingService.swift
//  TrainInformationService
//

import Foundation

public struct DepartingService: Codable {
	public let serviceId: String
	public let destination: String
    public let via: String?
    public let origin: String
	public let departureTime: String
	public let currentStatus: String
	public let delayReason: String?
    public let platform: String?
    public let operatingCompany: String
    public let cancelReason: String?
    public let length: Int
    public let currentLocation: String
}
