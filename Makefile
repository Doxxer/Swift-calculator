XCODE6 := /Applications/Xcode6-Beta3.app

XCODE6_TOOLCHAIN := $(XCODE6)/Contents/Developer/Toolchains/XcodeDefault.xctoolchain
XCODE6_SDK := $(XCODE6)/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.10.sdk

SWIFT = $(XCODE6_TOOLCHAIN)/usr/bin/swift
SWIFTFLAGS = -frontend -Ofast -module-name $(APPNAME) -sdk $(XCODE6_SDK)
SWIFTLINKERFLAGS = -force_load $(XCODE6_TOOLCHAIN)/usr/lib/arc/libarclite_macosx.a -syslibroot $(XCODE6_SDK) -lSystem -arch x86_64 -L $(XCODE6_TOOLCHAIN)/usr/lib/swift/macosx -rpath $(XCODE6_TOOLCHAIN)/usr/lib/swift/macosx -macosx_version_min 10.9.0 -no_objc_category_merging

APPNAME = calc
srcdir = SwiftCalculator
builddir = obj
CODE := $(shell ls $(srcdir)/*.swift | xargs -n1 basename)
OBJECTS = $(patsubst %, $(builddir)/%, $(CODE:.swift=.o))
SOURCES = $(patsubst %, $(srcdir)/%, $(CODE))

all: $(builddir) $(APPNAME)

$(builddir):
	mkdir -p $(builddir)
	
####################

$(builddir)/%.o: $(srcdir)/%.swift
	$(SWIFT) $(SWIFTFLAGS) -c -primary-file $< $(SOURCES) -o $@

####################

calc: $(OBJECTS)
	ld $(SWIFTLINKERFLAGS) $(OBJECTS) -o $(APPNAME)

clean:
	rm -rf $(builddir)
	rm -rf $(APPNAME)
	
run:
	./$(APPNAME) sample.txt

.PHONY: clean