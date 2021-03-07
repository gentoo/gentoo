cmake_minimum_required (VERSION 2.6)
project(fasttree C)

option(USE_OPENMP "Use OpenMP to parallelize many of the steps in computing a tree" ON)
option(USE_DOUBLE "Use double precission" OFF)
option(HAS_SSE3 "Use SSE2/SSE3 instructions to speed up some inner loops" ON)

if(USE_OPENMP)
	SET( CMAKE_C_FLAGS  "${CMAKE_C_FLAGS} -DOPENMP -fopenmp" )
	SET( CMAKE_EXE_LINKER_FLAGS  "${CMAKE_EXE_LINKER_FLAGS} -DOPENMP -fopenmp" )
endif(USE_OPENMP)

if(USE_DOUBLE)
	SET( CMAKE_C_FLAGS  "${CMAKE_C_FLAGS} -DUSE_DOUBLE" )
endif(USE_DOUBLE)

if(NOT HAS_SSE3)
	SET( CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -DNO_SSE" )
endif(NOT HAS_SSE3)


add_executable(FastTree FastTree-${VERSION}.c)
add_executable(FastTreeUPGMA FastTreeUPGMA-${VERSION}.c)

target_link_libraries(FastTree m)
target_link_libraries(FastTreeUPGMA m)

install (TARGETS FastTree FastTreeUPGMA DESTINATION bin)

install(FILES MOTree.pm CompareTree.pl CompareToBootstrap.pl DESTINATION share/fasttree)
