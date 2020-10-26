project(CppHello)

cmake_minimum_required(VERSION 3.1)
set(CMAKE_MACOSX_RPATH 1)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib")

find_package(JlCxx)
get_target_property(JlCxx_location JlCxx::cxxwrap_julia LOCATION)
get_filename_component(JlCxx_location ${JlCxx_location} DIRECTORY)
set(CMAKE_INSTALL_RPATH "${CMAKE_INSTALL_PREFIX}/lib;${JlCxx_location}")

find_package( OpenCV REQUIRED )


message(STATUS "Found JlCxx at ${JlCxx_location}")

# videocapture.cpp
add_library(videocapture SHARED videocapture.cpp)
target_link_libraries(videocapture JlCxx::cxxwrap_julia JlCxx::cxxwrap_julia_stl ${OpenCV_LIBS})
target_include_directories( videocapture PUBLIC ${OpenCV_INCLUDE_DIRS} )

install(TARGETS
  videocapture
LIBRARY DESTINATION lib
ARCHIVE DESTINATION lib
RUNTIME DESTINATION bin)
