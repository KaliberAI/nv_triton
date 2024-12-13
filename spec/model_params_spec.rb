# frozen_string_literal: true

RSpec.describe NvTriton::ModelParams do
  DEFAULT_PARAMS = [
    {name: "max_tokens", datatype: "INT32", shape: [1, 1], contents: [50]},
    {name: "bad_words", datatype: "BYTES", shape: [1, 1], contents: [""]},
    {name: "stop_words", datatype: "BYTES", shape: [1, 1], contents: ["</s>"]},
    {name: "top_p", datatype: "FP32", shape: [1, 1], contents: [1.0]},
    {name: "temperature", datatype: "FP32", shape: [1, 1], contents: [0.1]},
    {name: "presence_penalty", datatype: "FP32", shape: [1, 1], contents: [0.0]},
    {name: "beam_width", datatype: "INT32", shape: [1, 1], contents: [1]},
    {name: "stream", datatype: "BOOL", shape: [1, 1], contents: [false]}
  ]

  it "creates default options" do
    model_params = described_class.new

    expect(model_params.params).to eql(DEFAULT_PARAMS)
  end

  it "sets 'max_tokens'" do
    model_params = described_class.new({max_tokens: 100})

    expect(model_params.max_tokens).to eql(
      {name: "max_tokens", datatype: "INT32", shape: [1, 1], contents: [100]}
    )
  end

  it "sets 'bad_words'" do
    model_params = described_class.new({bad_words: ["billy goat", "curse"]})

    expect(model_params.bad_words).to eql(
      {name: "bad_words", datatype: "BYTES", shape: [1, 2], contents: ["billy goat", "curse"]}
    )
  end

  it "sets 'stop_words'" do
    model_params = described_class.new({stop_words: ["cleveland", "</s>"]})

    expect(model_params.stop_words).to eql(
      {name: "stop_words", datatype: "BYTES", shape: [1, 2], contents: ["cleveland", "</s>"]}
    )
  end

  it "sets 'top_p'" do
    model_params = described_class.new({top_p: 0.5})

    expect(model_params.top_p).to eql(
      {name: "top_p", datatype: "FP32", shape: [1, 1], contents: [0.5]}
    )
  end

  it "sets 'temperature'" do
    model_params = described_class.new({temperature: 0.5})

    expect(model_params.temperature).to eql(
      {name: "temperature", datatype: "FP32", shape: [1, 1], contents: [0.5]}
    )
  end

  it "sets 'presence_penalty'" do
    model_params = described_class.new({presence_penalty: 0.5})

    expect(model_params.presence_penalty).to eql(
      {name: "presence_penalty", datatype: "FP32", shape: [1, 1], contents: [0.5]}
    )
  end

  it "sets 'beam_width'" do
    model_params = described_class.new({beam_width: 2})

    expect(model_params.beam_width).to eql(
      {name: "beam_width", datatype: "INT32", shape: [1, 1], contents: [2]}
    )
  end

  it "sets 'stream'" do
    model_params = described_class.new({stream: true})

    expect(model_params.stream).to eql(
      {name: "stream", datatype: "BOOL", shape: [1, 1], contents: [true]}
    )
  end
 end
