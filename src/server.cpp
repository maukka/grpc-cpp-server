#include <grpcpp/grpcpp.h>
#include "../helloworld.pb.h"
#include "../helloworld.grpc.pb.h"


using grpc::Server;
using grpc::ServerBuilder;
using grpc::ServerContext;
using grpc::Status;

class GreeterService final : public helloworld::Greeter::Service {
public:
    Status SayHello(ServerContext* context,
                    const helloworld::HelloRequest* request,
                    helloworld::HelloReply* reply) override {
        reply->set_message("Hello " + request->name());
        return Status::OK;
    }
};

int main() {
    std::string server_address("0.0.0.0:50051");
    GreeterService service;

    ServerBuilder builder;
    builder.AddListeningPort(server_address, grpc::InsecureServerCredentials());
    builder.RegisterService(&service);

    std::unique_ptr<Server> server(builder.BuildAndStart());
    server->Wait();
}