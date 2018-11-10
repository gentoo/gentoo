CXX ?= g++
CXXFLAGS ?= -O3
LIBS=-lpthread

qpress:
	$(CXX) $(CXXFLAGS) qpress.cpp aio.cpp quicklz.c utilities.cpp -o $@ $(LIBS)
