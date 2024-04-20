cmake_minimum_required (VERSION 2.6)
project (DIAGRTB Fortran)

option (EXAMPLES "Instal additional example files" OFF)

add_executable(diagrtb diagrtb.f)

install (TARGETS diagrtb DESTINATION bin)

if ( EXAMPLES )
	install (DIRECTORY ../Try_RTB2011 DESTINATION share/diagrtb/examples)
endif (EXAMPLES)
