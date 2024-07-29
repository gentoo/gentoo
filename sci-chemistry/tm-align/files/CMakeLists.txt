cmake_minimum_required (VERSION 2.6)
project (TMTools Fortran)
add_executable(TMalign TMalign.f)
add_executable(TMscore TMscore.f)

install (TARGETS TMalign TMscore DESTINATION bin)
