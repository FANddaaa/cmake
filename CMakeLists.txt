cmake_minimum_required(VERSION 2.8)
project(testCmake)

set(MAIN_GO_PATH "cmd/main.go")
set(BINARY_FILE  "cmakeTest")
set(VERSION      "1.0.0")
set(DESCRIPTION  "Test cmake")

##### make build #####
add_custom_command(
    OUTPUT noarch/noarch_bin.tar.gz
    # COMMAND echo WORKING_DIRECTORY=${WORKING_DIRECTORY} CMAKE_SOURCE_DIR=${CMAKE_SOURCE_DIR}
    # COMMAND env
    # COMMAND pwd

    COMMAND ${CMAKE_COMMAND} -E remove_directory noarch
    COMMAND ${CMAKE_COMMAND} -E make_directory noarch
    COMMAND GOARCH=amd64 go build -o noarch/${BINARY_FILE}-x86_64 ${CMAKE_SOURCE_DIR}/${MAIN_GO_PATH}
    COMMAND GOARCH=arm64 go build -o noarch/${BINARY_FILE}-aarch64 ${CMAKE_SOURCE_DIR}/${MAIN_GO_PATH}
    COMMAND ${CMAKE_COMMAND} -E tar czvf noarch/noarch_bin.tar.gz noarch/${BINARY_FILE}-x86_64 noarch/${BINARY_FILE}-aarch64

    # WORKING_DIRECTORY ${CMAKE_BINARY_DIR} # 等价于${CMAKE_SOURCE_DIR}/${BUILD_PATH}
    COMMENT "构建多架构二进制文件并打包"
)
add_custom_target(build
    DEPENDS noarch/noarch_bin.tar.gz
    COMMENT "构建目标：生成多架构二进制文件压缩包"
)

##### make install #####
install(FILES _build/noarch/noarch_bin.tar.gz DESTINATION ./noarch)
## install(FILES README.md DESTINATION .)
## install(DIRECTORY cmd DESTINATION .)

##### make package #####
set(CPACK_GENERATOR                    "RPM")
set(CPACK_RPM_PACKAGE_RELEASE          1)
set(CPACK_RPM_PACKAGE_RELEASE_DIST     "centos7")
set(CPACK_RPM_PACKAGE_ARCHITECTURE     "noarch")
set(CPACK_RPM_SPEC_INSTALL_POST        "/bin/true") # disable strip
set(CPACK_RPM_POST_INSTALL_SCRIPT_FILE "${CMAKE_CURRENT_SOURCE_DIR}/scripts/psg-agent_post.sh")
set(CPACK_RPM_PACKAGE_AUTOREQ          0)

set(CPACK_PACKAGE_NAME                 ${BINARY_FILE})
set(CPACK_PACKAGE_VERSION              ${VERSION})
set(CPACK_SYSTEM_NAME                  ${CPACK_RPM_PACKAGE_RELEASE}.${CPACK_RPM_PACKAGE_RELEASE_DIST}.${CPACK_RPM_PACKAGE_ARCHITECTURE})
set(CPACK_PACKAGE_DESCRIPTION_SUMMARY  ${DESCRIPTION})
set(CPACK_PACKAGE_CONTACT              "xuyifan1227@qq.com")
set(CPACK_PACKAGING_INSTALL_PREFIX     "usr/local/${BINARY_FILE}")
include(CPack)