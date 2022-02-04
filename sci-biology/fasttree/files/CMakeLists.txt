cmake_minimum_required (VERSION 2.8.12)
project(fasttree C)

include(GNUInstallDirs)

option(USE_OPENMP "Use OpenMP to parallelize many of the steps in computing a tree" ON)
option(USE_DOUBLE "Use double precision" OFF)
option(HAS_SSE3 "Use SSE2/SSE3 instructions to speed up some inner loops" ON)

if(USE_OPENMP)
	set( CMAKE_C_FLAGS  "${CMAKE_C_FLAGS} -DOPENMP -fopenmp" )
	set( CMAKE_EXE_LINKER_FLAGS  "${CMAKE_EXE_LINKER_FLAGS} -DOPENMP -fopenmp" )
endif()

if(USE_DOUBLE)
	set( CMAKE_C_FLAGS  "${CMAKE_C_FLAGS} -DUSE_DOUBLE" )
endif()

if(NOT HAS_SSE3)
	set( CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -DNO_SSE" )
endif()

add_executable(FastTree FastTree-${VERSION}.c)
add_executable(FastTreeUPGMA FastTreeUPGMA-${VERSION}.c)

target_link_libraries(FastTree m)
target_link_libraries(FastTreeUPGMA m)

install (TARGETS FastTree FastTreeUPGMA DESTINATION ${CMAKE_INSTALL_BINDIR})

install(FILES MOTree.pm CompareTree.pl CompareToBootstrap.pl DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/fasttree)
