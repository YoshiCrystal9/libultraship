set(CMAKE_POLICY_DEFAULT_CMP0077 NEW)

# ========= ImGui =========
target_include_directories(ImGui PUBLIC ${DEVKITPRO}/portlibs/switch/include/)

#=================== SDL3 ===================
find_package(SDL3 QUIET)
if (NOT ${SDL3_FOUND})
    FetchContent_Declare(
            SDL3
            GIT_REPOSITORY https://github.com/p-sam/SDL.git
            GIT_TAG switch-sdl-3.4.12-audout
            OVERRIDE_FIND_PACKAGE
    )
    message("SDL3 not found. Downloading now...")
    FetchContent_MakeAvailable(SDL3)
    message("SDL3 downloaded to " ${FETCHCONTENT_BASE_DIR}/sdl3-src)
endif()

#=================== nlohmann-json ===================
find_package(nlohmann_json QUIET)
if (NOT ${nlohmann_json_FOUND})
    FetchContent_Declare(
        nlohmann_json
        GIT_REPOSITORY https://github.com/nlohmann/json.git
        GIT_TAG v3.11.3
        OVERRIDE_FIND_PACKAGE
    )
    FetchContent_MakeAvailable(nlohmann_json)
endif()

#=================== tinyxml2 ===================
find_package(tinyxml2 QUIET)
if (NOT ${tinyxml2_FOUND})
    set(tinyxml2_BUILD_TESTING OFF)
    FetchContent_Declare(
        tinyxml2
        GIT_REPOSITORY https://github.com/leethomason/tinyxml2.git
        GIT_TAG 10.0.0
        OVERRIDE_FIND_PACKAGE
    )
    FetchContent_MakeAvailable(tinyxml2)
endif()

#=================== spdlog ===================
find_package(spdlog QUIET)
if (NOT ${spdlog_FOUND})
    add_compile_definitions(SPDLOG_PREVENT_CHILD_FD) # disables fcntl(FD_CLOEXEC)
    set(SPDLOG_BUILD_EXAMPLE OFF)
    FetchContent_Declare(
        spdlog
        GIT_REPOSITORY https://github.com/gabime/spdlog.git
        GIT_TAG v1.14.1
        OVERRIDE_FIND_PACKAGE
    )
    FetchContent_MakeAvailable(spdlog)
endif()

target_compile_definitions(spdlog PRIVATE -D_POSIX_C_SOURCE=200809L)

#=================== libzip ===================
find_package(libzip QUIET)
if (NOT ${libzip_FOUND})
    set(CMAKE_POLICY_DEFAULT_CMP0077 NEW)
    set(BUILD_TOOLS OFF)
    set(BUILD_REGRESS OFF)
    set(BUILD_EXAMPLES OFF)
    set(BUILD_DOC OFF)
    set(BUILD_OSSFUZZ OFF)
    set(BUILD_SHARED_LIBS OFF)
    set(ENABLE_ZSTD OFF)
    FetchContent_Declare(
        libzip
        GIT_REPOSITORY https://github.com/nih-at/libzip.git
        GIT_TAG v1.10.1
        OVERRIDE_FIND_PACKAGE
    )
    FetchContent_MakeAvailable(libzip)
    list(APPEND ADDITIONAL_LIB_INCLUDES ${libzip_SOURCE_DIR}/lib ${libzip_BINARY_DIR})
endif()

# ========= StormLib =========
if (INCLUDE_MPQ_SUPPORT)
    target_compile_definitions(storm PRIVATE _POSIX_C_SOURCE=200809L)
endif ()

target_link_libraries(ImGui PUBLIC SDL3::SDL3)