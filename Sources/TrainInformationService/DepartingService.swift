//
//  DepartingService.swift
//  TrainInformationService
//
//  Created by Dimitar Chakarov on 21/11/2018.
//  Copyright © 2018 Dimitar Chakarov. All rights reserved.
//

import Foundation

public struct DepartingService {
	let serviceId: String
	let destination: String
	let departureTime: String
	let currentStatus: String
	let delayReason: String?
}
