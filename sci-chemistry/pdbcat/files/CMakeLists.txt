cmake_minimum_required (VERSION 2.6)
project (pdbcat)
add_executable(pdbcat
	Common.C
	Common.h
	pdbcat.C
	PDBData.C
	PDBData.h)

install (TARGETS pdbcat DESTINATION bin)

