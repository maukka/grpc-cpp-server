cmake_minimum_required(VERSION 3.15)
project(cpp_grpc_minimal)

find_package(Protobuf REQUIRED)
find_package(gRPC REQUIRED)

set(CMAKE_CXX_STANDARD 17)

# Use pre-generated protobuf sources
set(GENERATED_SRCS
    src/helloworld.pb.cc
    src/helloworld.grpc.pb.cc
)

set(GENERATED_HDRS
    src/helloworld.pb.h
    src/helloworld.grpc.pb.h
)

add_executable(server
    src/server.cpp
    ${GENERATED_SRCS}
    ${GENERATED_HDRS}
)

target_link_libraries(server
    gRPC::grpc++
    protobuf::libprotobuf
)

add_executable(test_dummy tests/test_dummy.cpp)
