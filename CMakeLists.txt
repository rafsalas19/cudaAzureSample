cmake_minimum_required(VERSION 3.8 FATAL_ERROR)

project(HeatTransfer LANGUAGES CXX CUDA)

set(CMAKE_BUILD_TYPE ""
)

set( HT_ROOT_DIR
	${CMAKE_SOURCE_DIR}
)
set( INCLUDE_DIR
	${CMAKE_SOURCE_DIR}/includes
)

set( SOURCE_DIR
	${CMAKE_SOURCE_DIR}/src
)

set(HT_INC_DIR
	${INCLUDE_DIR}/HeatTransfer
)

set(HT_INCLUDES
	""
)

set(HT_SOURCES
	main.cu
)


# set( CONDUCTION_INC_DIR ${INCLUDE_DIR}/Conduction)

# set( CONDUCTION_SRC_DIR ${SOURCE_DIR}/Conduction)

# add_subdirectory(${CONDUCTION_SRC_DIR})


# specify the C++ standard
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED True)
SET(CUDA_NVCC_FLAGS "-G -pg -lineinfo")

add_executable(HeatTransfer ${HT_SOURCES} ${HT_INCLUDES})

set_target_properties( HeatTransfer PROPERTIES 	CUDA_SEPARABLE_COMPILATION ON)
	
set_property(TARGET HeatTransfer PROPERTY CUDA_ARCHITECTURES 60 61 62 70)

#include_directories(${HT_INC_DIR} ${CONDUCTION_INC_DIR})
include_directories(${HT_INC_DIR})
target_link_libraries(HeatTransfer)

install(TARGETS HeatTransfer 
        LIBRARY DESTINATION lib
        ARCHIVE DESTINATION lib
        RUNTIME DESTINATION bin
		INCLUDES DESTINATION include
		)
