cmake_minimum_required (VERSION 3.31)
project (pdbcat)

include(GNUInstallDirs)

add_executable(pdbcat
	Common.C
	Common.h
	pdbcat.C
	PDBData.C
	PDBData.h)

install (TARGETS pdbcat DESTINATION ${CMAKE_INSTALL_BINDIR})
