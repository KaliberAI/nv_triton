# frozen_string_literal: true

RSpec.describe NvTriton::ChatHistoryBuilder do
  SINGLE_MESSAGE_OUTPUT = "<|begin_of_text|>
<|start_header_id|>user<|end_header_id|>
who won the 2016 world series?<|eot_id|>
<|start_header_id|>assistant<|end_header_id|>
"
  MULTI_MESSAGE_OUTPUT = "<|begin_of_text|>
<|start_header_id|>user<|end_header_id|>
who won the 2016 world series?<|eot_id|>
<|start_header_id|>user<|end_header_id|>
who is the best team in baseball?<|eot_id|>
<|start_header_id|>assistant<|end_header_id|>
"

  it "templates out chat history for one message" do
    history_builder = described_class.new
    history = history_builder.build_history(messages: ["who won the 2016 world series?"])

    expect(history).to eql(SINGLE_MESSAGE_OUTPUT)
  end

  it "templates out chat history for multiple messages" do
    history_builder = described_class.new
    history = history_builder.build_history(
      messages: [
        "who won the 2016 world series?",
        "who is the best team in baseball?"
      ]
    )

    expect(history).to eql(MULTI_MESSAGE_OUTPUT)
  end
end
