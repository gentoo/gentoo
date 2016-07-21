project(alglib CXX)
cmake_minimum_required(VERSION 2.8)

INCLUDE(GNUInstallDirs)
INCLUDE_DIRECTORIES(${CMAKE_SOURCE_DIR}/src)
SET(VERSION 3.7.0)
SET(SOVERSION 3.7)

FILE(GLOB ALGLIB_SRC_LIB "src/*.cpp")
FILE(GLOB ALGLIB_HDR_LIB "src/*.h")

ADD_LIBRARY(alglib SHARED ${ALGLIB_SRC_LIB})
SET_TARGET_PROPERTIES(alglib PROPERTIES 
  VERSION ${VERSION}
  SOVERSION ${SOVERSION})

INSTALL(TARGETS alglib DESTINATION ${CMAKE_INSTALL_LIBDIR}/)
INSTALL(FILES ${ALGLIB_HDR_LIB} DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})

#===========================================================
ADD_EXECUTABLE(test_c tests/test_c.cpp)
TARGET_LINK_LIBRARIES(test_c alglib)
#INSTALL(TARGETS test_c DESTINATION ${CMAKE_INSTALL_BINDIR}/)
#===========================================================
ADD_EXECUTABLE(test_i tests/test_i.cpp)
TARGET_LINK_LIBRARIES(test_i alglib)
#INSTALL(TARGETS test_i DESTINATION ${CMAKE_INSTALL_BINDIR}/)
#===========================================================

enable_testing()
add_test( test_c ${CMAKE_BUILD_DIR}/test_c)
add_test( test_i ${CMAKE_BUILD_DIR}/test_i)
