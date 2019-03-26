SHA=$(shell git rev-parse HEAD)
BRANCH=$(shell git name-rev --name-only HEAD)

install:
	carthage bootstrap --no-use-binaries
	sudo gem install xcpretty
	sudo gem install slather
	mkdir .build || true
	curl -L https://codeclimate.com/downloads/test-reporter/test-reporter-latest-darwin-amd64 > .build/cc-test-reporter
	chmod +x .build/cc-test-reporter

ios:
	set -o pipefail && xcodebuild test -configuration Release ONLY_ACTIVE_ARCH=YES -enableCodeCoverage YES -scheme "UCLKit iOS" -destination 'platform=iOS Simulator,name=iPhone 7' | xcpretty

macos:
	set -o pipefail && xcodebuild test -configuration Release -enableCodeCoverage YES -scheme "UCLKit macOS" -destination 'platform=OS X,arch=x86_64' | xcpretty

watchos:
	set -o pipefail && xcodebuild -configuration Release ONLY_ACTIVE_ARCH=YES -scheme "UCLKit watchOS" -destination 'platform=watchOS Simulator,name=Apple Watch Series 3 - 42mm' build | xcpretty

tvos:
	set -o pipefail && xcodebuild test -configuration Release ONLY_ACTIVE_ARCH=YES -enableCodeCoverage YES -scheme "UCLKit tvOS" -destination 'platform=tvOS Simulator,name=Apple TV 4K' | xcpretty

coverage:
	.build/cc-test-reporter before-build
	slather coverage -x --scheme "UCLKit iOS" --output-directory . UCLKit.xcodeproj
	.build/cc-test-reporter after-build -t cobertura --exit-code $?

all:
	make ios
	make macos
	make watchos
	make tvos

deploy:
	carthage build --no-skip-current
	carthage archive UCLKit
