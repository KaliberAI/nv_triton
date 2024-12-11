# frozen_string_literal: true

require 'thor'
require 'nv_triton'

module NvTriton
  class CLI < Thor
    PROTO_DIR = "#{NvTriton.root}/triton_common/protobuf"
    GRPC_GENERATOR = "grpc_tools_ruby_protoc"
    RUBY_OUT_DIR = "#{NvTriton.root}/lib"
    GRPC_OUT_DIR = "#{NvTriton.root}/lib"

    desc "generate_proto", "Generates protobuff classes from triton_common .proto files"
    def generate_proto
      proto_files = get_protos

      proto_files.each do |proto_file|
        say "Generating implementation for #{proto_file}... "
        system("#{GRPC_GENERATOR} -I #{PROTO_DIR}/ --ruby_out=#{RUBY_OUT_DIR} --grpc_out=#{GRPC_OUT_DIR} #{PROTO_DIR}/#{proto_file}")
        say "done", :blue
      end
    end

    desc "health_check", "Checks the health of the server connection"
    def health_check
      begin
        client = NvTriton::Client.new
        if client.healthy?
          say "OK", :green
        else
          say "BAD", :red
        end
      rescue NvTriton::Error => e
        say "Error: #{e.message}", :red
        exit 1
      end
    end

    desc "inference_live_check", "Checks the liveness of the inference server"
    def inference_live_check
      begin
        client = NvTriton::Client.new
        if client.server_live?
          say "LIVE", :green
        else
          say "DEAD", :red
        end
      rescue NvTriton::Error => e
        say "Error: #{e.message}", :red
        exit 1
      end
    end

    desc "inference_ready_check", "Checks the readyness of the inference server"
    def inference_ready_check
      begin
        client = NvTriton::Client.new
        if client.server_ready?
          say "READY", :green
        else
          say "NOT READY", :red
        end
      rescue NvTriton::Error => e
        say "Error: #{e.message}", :red
        exit 1
      end
    end

    desc "model_ready_check", "Checks the readyness of the model on the inference server"
    method_option :name, aliases: "-n"
    method_option :version, aliases: "-v"
    def model_ready_checks
      begin
        version = options[:version] || "1"
        client = NvTriton::Client.new
        if client.model_ready?(name: options[:name], version: version)
          say "#{options[:name]} - #{version} READY", :green
        else
          say "#{options[:name]} - #{version} NOT READY", :red
        end
      rescue NvTriton::Error => e
        say "Error: #{e.message}", :red
        exit 1
      end
    end

    no_commands do
      def get_protos
        say "Reading #{PROTO_DIR}... "
        proto_files =  Dir.children(PROTO_DIR).filter do |filename|
          filename.end_with?(".proto")
        end
        say "done", :blue

        proto_files
      end
    end
  end
end
