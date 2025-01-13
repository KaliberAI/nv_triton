# frozen_string_literal: true

begin
  require 'health_services_pb'
  HEALTH_SERVICE_LOADED = true
rescue LoadError
  HEALTH_SERVICE_LOADED = false
end

begin
  require 'grpc_service_services_pb'
  INFERENCE_SERVICE_LOADED = true
rescue LoadError
  INFERENCE_SERVICE_LOADED = false
end

module NvTriton
  # Note: The client MUST NOT have a leading `http://` or `https://` on the `trition_url` argument.
  # Including the protocol prefix causes the connection to fail with `Domain name not found`.
  class Client
    def initialize(triton_url:)
      if HEALTH_SERVICE_LOADED
        @health_service_stub = Grpc::Health::V1::Health::Stub.new(triton_url, :this_channel_is_insecure)
      end

      if INFERENCE_SERVICE_LOADED
        @inference_service_stub = Inference::GRPCInferenceService::Stub.new(triton_url, :this_channel_is_insecure)
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

    def server_live?
      unless @inference_service_stub
        raise NvTriton::Error, "gRPC inference service is not defined. Run the protobuf generator and try again."
      end

      req = Inference::ServerLiveRequest.new
      res = @inference_service_stub.server_live(req)

      res.live
    end

    def server_ready?
      unless @inference_service_stub
        raise NvTriton::Error, "gRPC inference service is not defined. Run the protobuf generator and try again."
      end

      req = Inference::ServerReadyRequest.new
      res = @inference_service_stub.server_ready(req)

      res.ready
    end

    def model_ready?(name:, version:)
      unless @inference_service_stub
        raise NvTriton::Error, "gRPC inference service is not defined. Run the protobuf generator and try again."
      end

      req = Inference::ModelReadyRequest.new(name: name, version: version)
      res = @inference_service_stub.model_ready(req)

      res.ready
    end

    def server_metadata
      unless @inference_service_stub
        raise NvTriton::Error, "gRPC inference service is not defined. Run the protobuf generator and try again."
      end

      req = Inference::ServerMetadataRequest.new
      res = @inference_service_stub.server_metadata(req)

      res.to_h
    end

    def model_metadata(name:, version:)
      unless @inference_service_stub
        raise NvTriton::Error, "gRPC inference service is not defined. Run the protobuf generator and try again."
      end

      req = Inference::ModelMetadataRequest.new(name: name, version: version)
      res = @inference_service_stub.model_metadata(req)

      res.to_h
    end

    def chat(model_name:, input:, model_params:)
      unless @inference_service_stub
        raise NvTriton::Error, "gRPC inference service is not defined. Run the protobuf generator and try again."
      end

      rendered_template = ChatHistoryBuilder.new.build_history(messages: [input])

      req = InferenceRequestBuilder.new(model_name: model_name, model_params: model_params)
        .input(name: "text_input", shape: [1, 1], datatype: "BYTES", contents: [rendered_template])
        .output(name: "text_output")
        .build

      # Streaming infer requires an enumerable as input
      res = @inference_service_stub.model_stream_infer([req])
      outputs = res.map do |r|
        # Encode the raw_output_contents as a "UTF-8" string replacing invalid or undefined bytes.
        # This is needed because the bytes returned in the response contains a leading non-UTF-8 byte
        # that can't be serialized in a JSON response.
        r.infer_response.raw_output_contents[0].encode("UTF-8", invalid: :replace, undef: :replace)
      end

      outputs[0]
    end
  end
end
