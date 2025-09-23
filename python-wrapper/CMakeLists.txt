cmake_minimum_required(VERSION 3.10)
project(python_wrapper
        VERSION 1.0.0
        DESCRIPTION "Robocomp dsr python wrapper library"
        LANGUAGES CXX)

find_package(Qt5 COMPONENTS Core REQUIRED)
find_package(Eigen3 3.3 REQUIRED NO_MODULE)

if(NOT PYBIND_FORCE_PYTHON312)
        find_package(PythonLibs REQUIRED)
        find_package(Python3 COMPONENTS Interpreter Development)

else()
        set(Python3_SITEARCH "/usr/local/lib/python3.12/dist-packages")
        set(PYTHON_LIBRARIES "/usr/lib/x86_64-linux-gnu/libpython3.12.so")
        set(PYTHON_INCLUDE_DIRS "/usr/include/python3.12")
endif()

find_package(pybind11 CONFIG REQUIRED)

if(DEFINED ENV{ROS_DISTRO})
        find_package(fastrtps 2.14.4 REQUIRED)
        find_package(fastcdr REQUIRED)
        include_directories(${fastrtps_INCLUDE_DIR})
        include_directories(${fastcdr_INCLUDE_DIR})
endif()

# Use pybind11_add_module for proper wheel generation
pybind11_add_module(pydsr python_api.cpp)

target_link_libraries(pydsr
        PRIVATE
        Qt5::Core
        Eigen3::Eigen
        Robocomp::dsr_api
        Robocomp::dsr_core
        ${PYTHON_LIBRARIES}
)

target_include_directories(pydsr
        PUBLIC

        # Headers of DSR Api and Core
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/../core/include/>
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/../api/include/>

        # Own include
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include/>
        PRIVATE
        ${PYTHON_INCLUDE_DIRS}
)

set_target_properties(pydsr PROPERTIES
        CMAKE_CXX_STANDARD 20
        CXX_STANDARD_REQUIRED ON
        CXX_EXTENSIONS ON
        Python_ADDITIONAL_VERSIONS 3.8

        # Enable position independent code for shared libraries
        POSITION_INDEPENDENT_CODE ON

        # Remove the prefix to match Python module naming
        PREFIX "${PYTHON_MODULE_PREFIX}"
        SUFFIX "${PYTHON_MODULE_EXTENSION}"
)

# set (CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -fno-omit-frame-pointer -fsanitize=address")
# set (CMAKE_LINKER_FLAGS_DEBUG "${CMAKE_LINKER_FLAGS_DEBUG} -fno-omit-frame-pointer -fsanitize=address")
target_compile_options(pydsr PRIVATE -O1 -g -fmax-errors=5 -std=c++20)

# Detect the virtual environment and set the installation directory
if(DEFINED ENV{VIRTUAL_ENV})
        set(pydsr_INSTALL_PYTHONDIR "$ENV{VIRTUAL_ENV}/lib/python${Python3_VERSION_MAJOR}.${Python3_VERSION_MINOR}/site-packages")
else()
        set(pydsr_INSTALL_PYTHONDIR "${Python3_SITEARCH}")
endif()

message(STATUS "Installing to: ${pydsr_INSTALL_PYTHONDIR}")
install(TARGETS pydsr DESTINATION ${pydsr_INSTALL_PYTHONDIR} COMPONENT module)

# Generate wheel package using setup.py
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/setup.py.in ${CMAKE_CURRENT_BINARY_DIR}/setup.py @ONLY)
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/pyproject.toml.in ${CMAKE_CURRENT_BINARY_DIR}/pyproject.toml @ONLY)

# Add custom command to build wheel automatically after building pydsr
add_custom_command(TARGET pydsr POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy $<TARGET_FILE:pydsr> ${CMAKE_CURRENT_BINARY_DIR}/
        COMMAND ${Python3_EXECUTABLE} -m pip wheel . --no-deps --wheel-dir=${CMAKE_CURRENT_BINARY_DIR}/dist
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        COMMENT "Building Python wheel package automatically"
)

# Optional: Create a separate wheel target for manual building
add_custom_target(wheel_only
        COMMAND ${CMAKE_COMMAND} -E copy $<TARGET_FILE:pydsr> ${CMAKE_CURRENT_BINARY_DIR}/
        COMMAND ${Python3_EXECUTABLE} -m pip wheel . --no-deps --wheel-dir=${CMAKE_CURRENT_BINARY_DIR}/dist
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        DEPENDS pydsr
        COMMENT "Building Python wheel package manually"
)
