SHA=$(shell git rev-parse HEAD)
BRANCH=$(shell git name-rev --name-only HEAD)

install:
	brew outdated carthage || brew upgrade carthage || brew install carthage
	carthage bootstrap

test:
	bundle exec fastlane code_coverage configuration:Debug --env default
