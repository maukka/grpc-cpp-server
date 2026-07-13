#!/usr/bin/bash

echo "=== Generating Protobuf and gRPC files ==="

protoc \
  --cpp_out=. \
  --grpc_out=. \
  --plugin=protoc-gen-grpc=/mingw64/bin/grpc_cpp_plugin.exe \
  -I=proto \
  proto/helloworld.proto

echo "=== Compiling with g++ ==="

g++ src/server.cpp helloworld.pb.cc helloworld.grpc.pb.cc \
    $(pkg-config --cflags --libs grpc++) \
    $(pkg-config --cflags --libs protobuf) \
    -o server.exe

echo "=== Build complete ==="