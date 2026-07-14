cmake_minimum_required(VERSION 3.16)
project(grpc_server CXX)

find_package(Protobuf REQUIRED)
find_package(PkgConfig REQUIRED)

pkg_check_modules(GRPC REQUIRED grpc++)

add_executable(server
    src/server.cpp
    generated/helloworld.pb.cc
    generated/helloworld.grpc.pb.cc
)

target_include_directories(server PRIVATE
    ${CMAKE_SOURCE_DIR}/generated
    ${GRPC_INCLUDE_DIRS}
    ${Protobuf_INCLUDE_DIRS}
)

target_link_directories(server PRIVATE ${GRPC_LIBRARY_DIRS})
target_link_libraries(server PRIVATE ${GRPC_LIBRARIES} protobuf::libprotobuf)
