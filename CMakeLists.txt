cmake_minimum_required(VERSION 3.15)
project(cpp_grpc_minimal)

find_package(Protobuf REQUIRED)
find_package(gRPC REQUIRED)

set(CMAKE_CXX_STANDARD 17)

# Proto file
set(PROTO_SRC proto/helloworld.proto)

# Generate protobuf + gRPC sources
protobuf_generate_cpp(PROTO_SRCS PROTO_HDRS ${PROTO_SRC})
grpc_generate_cpp(GRPC_SRCS GRPC_HDRS ${PROTO_SRC})

# Server executable
add_executable(server
    src/server.cpp
    ${PROTO_SRCS}
    ${PROTO_HDRS}
    ${GRPC_SRCS}
    ${GRPC_HDRS}
)

target_link_libraries(server
    gRPC::grpc++
    protobuf::libprotobuf
)

# Dummy test
add_executable(test_dummy tests/test_dummy.cpp)