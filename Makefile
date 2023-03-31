prefix ?= /usr/local
bindir = $(prefix)/bin
libdir = $(prefix)/lib
buildroot = $(shell swift build -c release --show-bin-path)

build:
	xcrun swift build -c release --disable-sandbox

install: build
	# Seems like brew hasn't created this yet and it confuses 'install' so...
	mkdir -p "$(bindir)"
	# Install the binary
	install "$(buildroot)/xcgrapher" "$(bindir)"

uninstall:
	rm -rf "$(bindir)/xcgrapher"

lint:
	swiftlint --autocorrect .
	swiftlint .
	swiftformat .

test: 
	@END_TO_END_TEST=1 swift test

clean:
	rm -rf .build

.PHONY: build install uninstall clean
