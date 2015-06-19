cmake_minimum_required(VERSION 2.8)

project(Newton)
file(GLOB NewtonLibSrc
          ${CMAKE_SOURCE_DIR}/coreLibrary_200/source/core/*.cpp
	  ${CMAKE_SOURCE_DIR}/packages/dCustomJoints/*.cpp
	  ${CMAKE_SOURCE_DIR}/packages/dContainers/*.cpp
	  ${CMAKE_SOURCE_DIR}/packages/dMath/*.cpp
          #${CMAKE_SOURCE_DIR}/packages/dScene/*.cpp
          ${CMAKE_SOURCE_DIR}/coreLibrary_200/source/physics/*.cpp
)

file(GLOB NewtonLibH
          ${CMAKE_SOURCE_DIR}/coreLibrary_200/source/core/*.h
	  ${CMAKE_SOURCE_DIR}/packages/dCustomJoints/*.h
	  ${CMAKE_SOURCE_DIR}/packages/dContainers/*.h
	  ${CMAKE_SOURCE_DIR}/packages/dMath/*.h
          #${CMAKE_SOURCE_DIR}/packages/dScene/*.h
	  ${CMAKE_SOURCE_DIR}/packages/*.h
          ${CMAKE_SOURCE_DIR}/coreLibrary_200/source/physics/*.h
)

file(GLOB to_remove ${CMAKE_SOURCE_DIR}/coreLibrary_200/source/physics/dgVehicleConstraint.cpp
)
list(REMOVE_ITEM NewtonLibSrc ${to_remove})

set(NewtonSrc ${NewtonSrc}
	      ${CMAKE_SOURCE_DIR}/coreLibrary_200/source/newton/NewtonClass.cpp
	      ${CMAKE_SOURCE_DIR}/coreLibrary_200/source/newton/Newton.cpp
)

set(includeDirs
          ${CMAKE_SOURCE_DIR}/coreLibrary_200/source/core/
          ${CMAKE_SOURCE_DIR}/coreLibrary_200/source/physics/
	  ${CMAKE_SOURCE_DIR}/packages/dCustomJoints/
	  ${CMAKE_SOURCE_DIR}/packages/dContainers/
	  ${CMAKE_SOURCE_DIR}/packages/dMath/
	  ${CMAKE_SOURCE_DIR}/packages/dScene/
	  ${CMAKE_SOURCE_DIR}/packages/  
)

include_directories(${includeDirs})

add_definitions( -DJOINTLIBRARY_LIB -D_LINUX_VER )


SET(LIB_TYPE SHARED)
add_library(Newton ${LIB_TYPE} ${NewtonLibH} ${NewtonLibSrc} ${NewtonSrc})

INSTALL(TARGETS Newton
  RUNTIME DESTINATION bin
  LIBRARY DESTINATION lib
  ARCHIVE DESTINATION lib
)

INSTALL(FILES ${NewtonLibH} DESTINATION include)


