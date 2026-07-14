#!/usr/bin/bash

echo "=== Generating Protobuf and gRPC files ==="

# Always run from the project root
cd "$(dirname "$0")"

# Ensure src folder exists
mkdir -p src

# Generate protobuf files
protoc \
  --cpp_out=src \
  --grpc_out=src \
  --plugin=protoc-gen-grpc=/mingw64/bin/grpc_cpp_plugin.exe \
  -I=proto \
  proto/helloworld.proto

echo "=== Compiling with g++ ==="

g++ \
  src/server.cpp \
  src/helloworld.pb.cc \
  src/helloworld.grpc.pb.cc \
  $(pkg-config --cflags --libs grpc++) \
  $(pkg-config --cflags --libs protobuf) \
  -o server.exe
