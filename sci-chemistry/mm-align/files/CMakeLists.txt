cmake_minimum_required (VERSION 2.6)
project (MM-align Fortran)
add_executable(MMalign MM-align.f)

install (TARGETS MMalign DESTINATION bin)
