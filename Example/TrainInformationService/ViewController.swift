//
//  ViewController.swift
//  TrainInformationService
//
//  Created by dchakarov on 12/10/2018.
//  Copyright (c) 2018 dchakarov. All rights reserved.
//

import UIKit
import TrainInformationService

class ViewController: UIViewController {	
	override func viewDidLoad() {
		super.viewDidLoad()
		let trains = 5
		let station = "PAD"
		let trainInformationService = TrainInformationService(apiUrl: "https://lite.realtime.nationalrail.co.uk/OpenLDBWS/ldb11.asmx", token: "token")
		trainInformationService.departureBoard(for: station, items: trains) { result in
			switch result {
			case .success(let board):
				print(board)
			case .error(let error):
				print(error.localizedDescription)
			}
		}
	}
}

