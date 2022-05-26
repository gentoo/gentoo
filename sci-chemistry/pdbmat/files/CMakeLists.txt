cmake_minimum_required (VERSION 2.6)
project (PDBMAT Fortran)

include(GNUInstallDirs)

option (EXAMPLES "Instal additional example files" OFF)

add_executable(diagstd diagstd.f)
add_executable(pdbmat pdbmat.f)

install (TARGETS diagstd pdbmat DESTINATION bin)
install (FILES diagstd.README pdbmat.README DESTINATION ${CMAKE_INSTALL_DOCDIR})

if ( EXAMPLES )
	install (DIRECTORY ../Try_ENM2011 DESTINATION ${CMAKE_INSTALL_DOCDIR}/examples)
endif (EXAMPLES)
