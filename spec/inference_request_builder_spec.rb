# frozen_string_literal: true

RSpec.describe NvTriton::InferenceRequestBuilder do
  it "builds a new 'Inference::ModelInferRequest' object with the model name" do
    params = NvTriton::ModelParams.new
    builder = described_class.new(model_name: "llama-3.1-8b-instruct", model_params: params)

    expect(builder.build.model_name).to eql('llama-3.1-8b-instruct')
  end

  it "builds a new 'Inference::ModelInferRequest' object with model_params as input" do
    params = NvTriton::ModelParams.new
    builder = described_class.new(model_name: "llama-3.1-8b-instruct", model_params: params)

    infer_request = builder.build
    expect(infer_request.inputs.first.name).to eql(params.params.first[:name])
    expect(infer_request.inputs.last.name).to eql(params.params.last[:name])
  end

  it "adds an input" do
    params = NvTriton::ModelParams.new
    builder = described_class.new(model_name: "llama-3.1-8b-instruct", model_params: params)
    builder.input(name: "test_input", shape: [1, 1], datatype: "INT32", contents: [1])


    infer_request = builder.build
    expect(infer_request.inputs.last.name).to eql("test_input")
  end

  it "adds an output" do
    params = NvTriton::ModelParams.new
    builder = described_class.new(model_name: "llama-3.1-8b-instruct", model_params: params)
    builder.output(name: "text_content")

    infer_request = builder.build
    expect(infer_request.outputs.first.name).to eql("text_content")
  end
end
