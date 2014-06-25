SWIFT = /Applications/Xcode6-Beta.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/swift
SWIFTFLAGS = -sdk /Applications/Xcode6-Beta.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.10.sdk/ -O3 -v
APPNAME = calc
srcdir = "Swift Calculator"

all: $(APPNAME)

calc:
	xcrun $(SWIFT) $(SWIFTFLAGS) $(srcdir)/*.swift -o $(APPNAME)

clean:
	rm -rf $(APPNAME)
	
run:
	./$(APPNAME) sample.txt

.PHONY: clean