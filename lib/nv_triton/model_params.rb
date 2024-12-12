# frozen_string_literal: true

module NvTriton
  class ModelParams
    attr_reader :max_tokens, :bad_words, :stop_words, :top_p, :temperature, :presence_penalty, :beam_width, :stream

    def initialize(options = {})
      if options[:bad_words] && !options[:bad_words].kind_of?(Array)
        raise NvTriton::Error, "bad_words option must be an array of strings, got: #{options[:bad_words].class.name}"
      end

      if options[:stop_words] && !options[:stop_words].kind_of?(Array)
        raise NvTriton::Error, "stop_words option must be an array of strings, got: #{options[:stop_words].class.name}"
      end

      @max_tokens = { name: "max_tokens", datatype: "INT32", shape: [1, 1], contents: [options[:max_tokens] || 50] }
      bad_words = options[:bad_words] || [""]
      @bad_words = { name: "bad_words", datatype: "BYTES", shape: [1, bad_words.length], contents:  bad_words }
      stop_words = options[:stop_words] || ["</s>"]
      @stop_words = { name: "stop_words", datatype: "BYTES", shape: [1, stop_words.length], contents: stop_words }
      @top_p = { name: "top_p",  datatype: "FP32", shape: [1, 1], contents: [options[:top_p]&.to_f || 1.0] }
      @temperature = { name: "temperature", datatype: "FP32", shape: [1, 1], contents: [options[:temperature]&.to_f || 0.1] }
      presence_penalty = { name: "presence_penalty", datatype: "FP32", shape: [1, 1], contents: [options[:presence_penalty]&.to_f || 0.0] }
      @beam_width = { name: "beam_width", datatype: "INT32", shape: [1, 1], contents: [options[:beam_width]&.to_i || 1] }
      @stream = { name: "stream", datatype: "BOOL", shape: [1, 1], contents: [options[:stream] || false] }
    end

    def params
      instance_variables.map do |var|
        send("#{var.to_s.gsub('@','')}")
      end
    end
  end
end
