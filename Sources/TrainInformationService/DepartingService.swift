//
//  DepartingService.swift
//  TrainInformationService
//
//  Created by Dimitar Chakarov on 21/11/2018.
//  Copyright © 2018 Dimitar Chakarov. All rights reserved.
//

import Foundation

public struct DepartingService {
	public let serviceId: String
	public let destination: String
	public let departureTime: String
	public let currentStatus: String
	public let delayReason: String?
}
