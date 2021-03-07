cmake_minimum_required(VERSION 2.6)
project(UCHIME)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -D_FILE_OFFSET_BITS=64 -DUCHIMES=1")

# Simply copy the source files from the mk script
add_executable(uchime 
				addtargets2.cpp alignchime.cpp alignchimel.cpp alnparams.cpp alpha.cpp alpha2.cpp fractid.cpp getparents.cpp globalalign2.cpp make3way.cpp mx.cpp myutils.cpp path.cpp searchchime.cpp seqdb.cpp setnucmx.cpp sfasta.cpp tracebackbit.cpp uchime_main.cpp usort.cpp viterbifast.cpp writechhit.cpp)

INSTALL(TARGETS uchime
        DESTINATION bin)
