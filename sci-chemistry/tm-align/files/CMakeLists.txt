cmake_minimum_required (VERSION 3.28)
project (TMTools Fortran)

include(GNUInstallDirs)

add_executable(TMalign TMalign.f)
add_executable(TMscore TMscore.f)

install (TARGETS TMalign TMscore DESTINATION ${CMAKE_INSTALL_BINDIR})
