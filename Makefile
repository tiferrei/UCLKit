SHA=$(shell git rev-parse HEAD)
BRANCH=$(shell git name-rev --name-only HEAD)

install:
	carthage bootstrap
	sudo gem install xcpretty

ios:
	set -o pipefail && xcodebuild test -configuration Release ONLY_ACTIVE_ARCH=YES -enableCodeCoverage YES -workspace UCLKit.xcodeproj -scheme "UCLKit iOS" -destination 'platform=iOS Simulator,name=iPhone 7' | xcpretty

macos:
	set -o pipefail && xcodebuild test -configuration Release -enableCodeCoverage YES -workspace UCLKit.xcodeproj -scheme "UCLKit macOS" -destination 'platform=OS X,arch=x86_64' | xcpretty

watchos:
	set -o pipefail && xcodebuild -configuration Release ONLY_ACTIVE_ARCH=YES -workspace UCLKit.xcodeproj -scheme "UCLKit watchOS" -destination 'platform=watchOS Simulator,name=Apple Watch Series 3 - 42mm' build | xcpretty

tvos:
	set -o pipefail && xcodebuild test -configuration Release ONLY_ACTIVE_ARCH=YES -enableCodeCoverage YES -workspace UCLKit.xcodeproj -scheme "UCLKit tvOS" -destination 'platform=tvOS Simulator,name=Apple TV 4K' | xcpretty

all:
	make ios
	make macos
	make watchos
	make tvos

deploy:
	carthage build --no-skip-current
	carthage archive UCLKit
