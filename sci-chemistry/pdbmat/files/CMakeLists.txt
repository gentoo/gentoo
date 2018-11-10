cmake_minimum_required (VERSION 2.6)
project (PDBMAT Fortran)

option (EXAMPLES "Instal additional example files" OFF)

add_executable(diagstd diagstd.f)
add_executable(pdbmat pdbmat.f)

install (TARGETS diagstd pdbmat DESTINATION bin)
install (FILES diagstd.README pdbmat.README DESTINATION share/doc/pdbmat)

if ( EXAMPLES )
	install (DIRECTORY ../Try_ENM2011 DESTINATION share/pdbmat/examples)
endif (EXAMPLES)
