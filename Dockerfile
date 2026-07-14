FROM ubuntu:22.04 AS build

RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    git \
    pkg-config \
    protobuf-compiler \
    protobuf-compiler-grpc \
    libprotobuf-dev \
    libgrpc-dev \
    libgrpc++-dev

# Create missing gRPC CMake config files
RUN mkdir -p /usr/lib/x86_64-linux-gnu/cmake/grpc && \
    echo "include(/usr/lib/x86_64-linux-gnu/pkgconfig/grpc++.pc)" > /usr/lib/x86_64-linux-gnu/cmake/grpc/gRPCConfig.cmake && \
    echo "include(/usr/lib/x86_64-linux-gnu/pkgconfig/grpc.pc)" >> /usr/lib/x86_64-linux-gnu/cmake/grpc/gRPCConfig.cmake

WORKDIR /app
COPY . .

# Generate protobuf files
RUN mkdir -p generated && \
    protoc \
      --cpp_out=generated \
      --grpc_out=generated \
      --plugin=protoc-gen-grpc=/usr/bin/grpc_cpp_plugin \
      -I=proto \
      proto/helloworld.proto

# Build with CMake
RUN cmake -B build -S . && \
    cmake --build build --config Release

# Runtime image
FROM ubuntu:22.04

RUN apt-get update && apt-get install -y \
    libprotobuf-dev \
    libgrpc++1

WORKDIR /app
COPY --from=build /app/build/server /app/server

EXPOSE 50051
CMD ["./server"]
