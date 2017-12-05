SHA=$(shell git rev-parse HEAD)
BRANCH=$(shell git name-rev --name-only HEAD)

install:
	brew update
	carthage bootstrap --no-use-binaries

ios:
	set -o pipefail && xcodebuild test -configuration Release ONLY_ACTIVE_ARCH=YES -enableCodeCoverage YES -scheme "UCLKit iOS" -destination 'platform=iOS Simulator,name=iPhone X'

macos:
	set -o pipefail && xcodebuild test -configuration Release -enableCodeCoverage YES -scheme "UCLKit macOS" -destination 'platform=OS X,arch=x86_64'

watchos:
	set -o pipefail && xcodebuild -configuration Release ONLY_ACTIVE_ARCH=YES -scheme "UCLKit watchOS" -destination 'platform=watchOS Simulator,name=Apple Watch Series 3 - 42mm' build

tvos:
	set -o pipefail && xcodebuild test -configuration Release ONLY_ACTIVE_ARCH=YES -enableCodeCoverage YES -scheme "UCLKit tvOS" -destination 'platform=tvOS Simulator,name=Apple TV 4K'

all:
	make ios
	make macos
	make watchos
	make tvos

deploy:
	carthage build --no-skip-current
	carthage archive UCLKit
