cmake_minimum_required(VERSION 3.8 FATAL_ERROR)

project(HeatTransfer LANGUAGES CXX CUDA)

set(CMAKE_BUILD_TYPE
	CACHE "Build Type" 
)

set( HT_ROOT_DIR
	"CMAKE_SOURCE_DIR"
)
set( INCLUDE_DIR
	"CMAKE_SOURCE_DIR/include"
)

set( SOURCE_DIR
	"CMAKE_SOURCE_DIR/src"
)

set(HT_INC_DIR
	${INCLUDE_DIR}"/HeatTransfer"
)

set(HT_INCLUDES
	""
)
set(HT_SOURCES
	main.cu
)
add_subdirectory(HT_INC_DIR)

set( CONDUCTION_INC_DIR ${INCLUDE_DIR}"/Conduction")

set( CONDUCTION_SRC_DIR ${SOURCE_DIR}"/Conduction")
add_subdirectory(CONDUCTION_INC_DIR)
add_subdirectory(CONDUCTION_SRC_DIR)







# specify the C++ standard
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED True)
set_property(TARGET CudaTest PROPERTY CUDA_SEPARABLE_COMPILATION ON)

add_executable(HeatTransfer HT_SOURCES HT_INCLUDES)

include_directories(HT_INC_DIR CONDUCTION_INC_DIR)
target_link_libraries(HeatTransfer Conduction)

install(TARGETS projectA 
        LIBRARY DESTINATION lib
        ARCHIVE DESTINATION lib
        RUNTIME DESTINATION bin
		INCLUDES DESTINATION include
		)