// swift-tools-version:4.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "TrainInformationService",
	products: [
		.library(name: "TrainInformationService", targets: ["TrainInformationService"]),
		],
	dependencies: [
		.package(url: "https://github.com/drmohundro/SWXMLHash.git", from: "4.7.0")
	],
	targets: [
		.target(
			name: "TrainInformationService",
			dependencies: ["SWXMLHash"]),
		]
)
