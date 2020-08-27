set(COND_INCLUDES

)
set(COND_SOURCES
)

add_library(Conduction COND_SOURCES COND_SOURCES )

target_include_directories(one PUBLIC include)
target_link_libraries(another PUBLIC one)
install(TARGETS Conduction
    LIBRARY DESTINATION lib
    ARCHIVE DESTINATION lib)