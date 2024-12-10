# frozen_string_literal: true

begin
  require 'health_services_pb'
  HEALTH_SERVICE_LOADED = true
rescue LoadError
  HEALTH_SERVICE_LOADED = false
end

module NvTriton
  class Client
    def initialize
      if HEALTH_SERVICE_LOADED
        @health_service_stub = Grpc::Health::V1::Health::Stub.new('localhost:8001', :this_channel_is_insecure)
      end
    end

    def healthy?
      unless @health_service_stub
        raise NvTriton::Error, "gRPC health service is not defined. Run the protobuf generator and try again."
      end

       req = Grpc::Health::V1::HealthCheckRequest.new
       res = @health_service_stub.check(req)

       res.status == :SERVING
    end
  end
end
