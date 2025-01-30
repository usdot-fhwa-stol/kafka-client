cmake_minimum_required(VERSION 3.10.2)

# where to find our CMake modules
set(CMAKE_MODULE_PATH "$ENV{CARMA_OPT_DIR}/cmake")
# Required for std::lock and syntax
set(CMAKE_CXX_STANDARD 17)



project(kafka-client
    DESCRIPTION "Kafka Client Library"
    HOMEPAGE_URL https://github.com/usdot-fhwa-stol/kafka-client
	VERSION 0.0.1
    LANGUAGES CXX
)


option(BUILD_PYTHON_BINDINGS 
    "BUILD PYTHON BINDINGS is used to configure whether or not to including building python module bindings into the cmake build process.
     **NOTE** Build python bindings is currently only support for native builds (not supported for cross-compile builds) " OFF)
option(BUILD_TESTS "Build tests" OFF)
option(CREATE_DEB_PACKAGE "Create Debian Package" OFF)

include(cmake/dependencies.cmake)
add_definitions(-DSPDLOG_ACTIVE_LEVEL=SPDLOG_LEVEL_TRACE)

add_library(${PROJECT_NAME} SHARED )

target_include_directories(${PROJECT_NAME} 
  PUBLIC
    $<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/include>
)
target_link_libraries(${PROJECT_NAME} PUBLIC RdKafka::rdkafka++ spdlog::spdlog )
set_target_properties(${PROJECT_NAME} PROPERTIES
    SOVERSION 1
)

include(CommonSource)
if (BUILD_TESTS)
    include(Testing)
    include(CodeCoverage)
endif()
include(InstallingGeneral)
include(InstallingConfigs)

if (CREATE_DEB_PACKAGE)
    include(Packing)
    set(CPACK_DEBIAN_PACKAGE_DEPENDS RdKafka spdlog)

endif()



