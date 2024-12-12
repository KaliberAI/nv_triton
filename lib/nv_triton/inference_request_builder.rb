# frozen_string_literal:  true

begin
  require 'grpc_service_services_pb'
  if INFERENCE_SERVICE_LOADED.nil?
    INFERENCE_SERVICE_LOADED = true
  end
rescue LoadError
  INFERENCE_SERVICE_LOADED = false
end

module NvTriton
  class InferenceRequestBuilder
    def initialize(model_name:, model_params:)
      unless INFERENCE_SERVICE_LOADED
        raise NvTriton::Error, "gRPC inference service is not defined. Run the protobuf generator and try again."
      end

      @model_name = model_name
      @inputs = model_params.params.map do |param|
        Inference::ModelInferRequest::InferInputTensor.new(
          name: param[:name],
          shape: param[:shape],
          datatype: param[:datatype],
          contents: tensor_contents(datatype: param[:datatype], contents: param[:contents])
        )
      end
      @outputs = []
    end

    def input(name:, shape:, datatype:, contents:)
      input = Inference::ModelInferRequest::InferInputTensor.new(
        name: name,
        shape: shape,
        datatype: datatype,
        contents: tensor_contents(datatype: datatype, contents: contents)
      )

      @inputs = @inputs.push(input)
      self
    end

    def output(name:)
      output = Inference::ModelInferRequest::InferRequestedOutputTensor.new(name: name)

      @outputs = @outputs.push(output)
      self
    end


    def build
      puts @inputs.inspect
      Inference::ModelInferRequest.new(model_name: @model_name, model_version: "1", inputs: @inputs, outputs: @outputs)
    end

    private

    # TODO: Apply the proper conversion of data in the match arms
    # Notes: Contents here is going to be an array
    def tensor_contents(datatype:, contents:)
      case datatype
      in "BOOL"
        Inference::InferTensorContents.new(bool_contents: contents)
      in "INT32"
        Inference::InferTensorContents.new(int_contents: contents)
      in "INT64"
        Inference::InferTensorContents.new(int64_contents: contents)
      in "UINT32"
        Inference::InferTensorContents.new(uint_contents: contents)
      in "UINT64"
        Inference::InferTensorContents.new(uint64_contents: contents)
      in "FP32"
        Inference::InferTensorContents.new(fp32_contents: contents)
      in "FP64"
        Inference::InferTensorContents.new(fp64_contents: contents)
      in "BYTES"
        Inference::InferTensorContents.new(bytes_contents: contents)
      end
    end
  end
end
