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

find_program(PROTOC protoc)
find_program(GRPC_CPP_PLUGIN grpc_cpp_plugin)

if(NOT PROTOC)
    message(FATAL_ERROR "protoc not found")
endif()

if(NOT GRPC_CPP_PLUGIN)
    message(FATAL_ERROR "grpc_cpp_plugin not found")
endif()

set(GENERATED_PROTO_SRCS
    ${CMAKE_CURRENT_BINARY_DIR}/helloworld.pb.cc
    ${CMAKE_CURRENT_BINARY_DIR}/helloworld.grpc.pb.cc
)

set(GENERATED_PROTO_HDRS
    ${CMAKE_CURRENT_BINARY_DIR}/helloworld.pb.h
    ${CMAKE_CURRENT_BINARY_DIR}/helloworld.grpc.pb.h
)

add_custom_command(
    OUTPUT ${GENERATED_PROTO_SRCS} ${GENERATED_PROTO_HDRS}
    COMMAND ${PROTOC}
        --grpc_out=${CMAKE_CURRENT_BINARY_DIR}
        --plugin=protoc-gen-grpc=${GRPC_CPP_PLUGIN}
        --cpp_out=${CMAKE_CURRENT_BINARY_DIR}
        ${PROTO_SRC}
    DEPENDS ${PROTO_SRC}
)

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