all: ld64 rebase

build_test: machocheck ObjectDump

ld64: debugline.o Options.o ld.o version.o
	$(CXX) $(LDFLAGS) -o $@ $^

machocheck: machochecker.o
	$(CXX) $(LDFLAGS) -o $@ $^

ObjectDump: ObjectDump.o debugline.o
	$(CXX) $(LDFLAGS) -o $@ $^
