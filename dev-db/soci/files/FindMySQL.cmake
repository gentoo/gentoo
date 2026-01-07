if (NOT TARGET MySQL::MySQL)
  set(MySQL_FOUND TRUE)
  add_library(MySQL INTERFACE)
  target_link_libraries(MySQL INTERFACE ${MySQL_LIBRARIES})
  target_include_directories(MySQL SYSTEM INTERFACE ${MySQL_INCLUDE_DIRS})
  add_library(MySQL::MySQL ALIAS MySQL)
endif()

