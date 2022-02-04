cmake_minimum_required(VERSION 3.0)
project(dtc)
message(${CMAKE_CURRENT_SOURCE_DIR})

add_compile_options(
    -Wall
    -O2 
    -flto
    -Wno-sign-compare
    -Wno-missing-field-initializers
    -Wno-unused-parameter
    -DNO_YAML
)

# build_extensions_files
set(cmake_caches 
    ${CMAKE_CURRENT_SOURCE_DIR}/cmake_install.cmake
    ${CMAKE_CURRENT_SOURCE_DIR}/CMakeFiles
    ${CMAKE_CURRENT_SOURCE_DIR}/CMakeCache.txt
)
execute_process(COMMAND rm -rf ${cmake_caches})
execute_process(COMMAND flex -o ${CMAKE_CURRENT_SOURCE_DIR}/dtc-lexer.lex.c ${CMAKE_CURRENT_SOURCE_DIR}/dtc-lexer.l)
execute_process(COMMAND bison -b ${CMAKE_CURRENT_SOURCE_DIR}/dtc-parser -d ${CMAKE_CURRENT_SOURCE_DIR}/dtc-parser.y)
execute_process(COMMAND cp -f ${CMAKE_CURRENT_SOURCE_DIR}/dtc-parser.tab.h ${CMAKE_CURRENT_SOURCE_DIR}/dtc-parser.h)

# include_dirs
include_directories(${CMAKE_CURRENT_SOURCE_DIR}/libfdt)

# libfdt.a
set(FDT_SRCS
    ${CMAKE_CURRENT_SOURCE_DIR}/libfdt/fdt.c
    ${CMAKE_CURRENT_SOURCE_DIR}/libfdt/fdt_check.c
    ${CMAKE_CURRENT_SOURCE_DIR}/libfdt/fdt_ro.c
    ${CMAKE_CURRENT_SOURCE_DIR}/libfdt/fdt_wip.c
    ${CMAKE_CURRENT_SOURCE_DIR}/libfdt/fdt_sw.c
    ${CMAKE_CURRENT_SOURCE_DIR}/libfdt/fdt_rw.c
    ${CMAKE_CURRENT_SOURCE_DIR}/libfdt/fdt_strerror.c
    ${CMAKE_CURRENT_SOURCE_DIR}/libfdt/fdt_empty_tree.c
    ${CMAKE_CURRENT_SOURCE_DIR}/libfdt/fdt_addresses.c
    ${CMAKE_CURRENT_SOURCE_DIR}/libfdt/fdt_overlay.c
    ${CMAKE_CURRENT_SOURCE_DIR}/libfdt/acpi.c
)
add_library(fdt STATIC ${FDT_SRCS})

# executable
set(CMAKE_C_FLAGS -static)

set(SRCS
    ${CMAKE_CURRENT_SOURCE_DIR}/checks.c 
    ${CMAKE_CURRENT_SOURCE_DIR}/data.c 
    ${CMAKE_CURRENT_SOURCE_DIR}/dtc.c 
    ${CMAKE_CURRENT_SOURCE_DIR}/dtc-lexer.lex.c 
    ${CMAKE_CURRENT_SOURCE_DIR}/dtc-parser.tab.c 
    ${CMAKE_CURRENT_SOURCE_DIR}/flattree.c 
    ${CMAKE_CURRENT_SOURCE_DIR}/fstree.c 
    ${CMAKE_CURRENT_SOURCE_DIR}/livetree.c 
    ${CMAKE_CURRENT_SOURCE_DIR}/srcpos.c 
    ${CMAKE_CURRENT_SOURCE_DIR}/treesource.c 
    ${CMAKE_CURRENT_SOURCE_DIR}/util.c
)
add_executable(dtc_static ${SRCS})
target_link_libraries(dtc_static fdt)

# install
set(CMAKE_INSTALL_PREFIX ${CMAKE_CURRENT_SOURCE_DIR}/install)
install(
    TARGETS dtc_static
    LIBRARY DESTINATION lib  # 动态库安装路径
    ARCHIVE DESTINATION lib  # 静态库安装路径
    RUNTIME DESTINATION bin  # 可执行文件安装路径
    PUBLIC_HEADER DESTINATION include  # 头文件安装路径
)
