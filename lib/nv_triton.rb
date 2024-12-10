# frozen_string_literal: true

require_relative "nv_triton/version"
require_relative "nv_triton/client"

module NvTriton
  class Error < StandardError; end
  # Your code goes here...

  def self.root
    File.dirname __dir__
  end
end
