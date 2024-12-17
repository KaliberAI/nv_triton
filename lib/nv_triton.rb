# frozen_string_literal: true

require_relative "nv_triton/version"
require_relative "nv_triton/client"
require_relative "nv_triton/inference_request_builder"
require_relative "nv_triton/chat_history_builder"
require_relative "nv_triton/model_params"

module NvTriton
  class Error < StandardError; end

  def self.root
    File.dirname __dir__
  end
end
