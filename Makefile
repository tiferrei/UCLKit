SHA=$(shell git rev-parse HEAD)
BRANCH=$(shell git name-rev --name-only HEAD)

install:
	brew update
	gem install xcpretty --no-rdoc --no-ri --no-document --quiet
	carthage bootstrap

ios:
	set -o pipefail && xcodebuild test -scheme "UCLKit iOS" -destination 'platform=iOS Simulator,name=iPhone 7' | xcpretty

macos:
	set -o pipefail && xcodebuild test -scheme "UCLKit macOS" -destination 'platform=OS X,arch=x86_64' | xcpretty

watchos:
	set -o pipefail && xcodebuild -scheme "UCLKit watchOS" -destination 'platform=watchOS Simulator,name=Apple Watch Series 2 - 42mm' build | xcpretty

tvos:
	set -o pipefail && xcodebuild test -scheme "UCLKit tvOS" -destination 'platform=tvOS Simulator,name=Apple TV 1080p' | xcpretty

all:
	make ios
	make macos
	make tvos

deploy:
	carthage build --no-skip-current
	carthage archive UCLKit
