# frozen_string_literal: true

require 'erb'

module NvTriton
  class ChatHistoryBuilder
    def initialize
      @history_template = ERB.new(
        File.read("#{NvTriton.root}/lib/templates/llama3_chat.erb"), trim_mode: '>')
    end

    def build_history(messages:)
      @history_template.result(binding)
    end
  end
end
