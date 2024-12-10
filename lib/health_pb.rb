# frozen_string_literal: true
# Generated by the protocol buffer compiler.  DO NOT EDIT!
# source: health.proto

require 'google/protobuf'


descriptor_data = "\n\x0chealth.proto\x12\x0egrpc.health.v1\"%\n\x12HealthCheckRequest\x12\x0f\n\x07service\x18\x01 \x01(\t\"\xa9\x01\n\x13HealthCheckResponse\x12\x41\n\x06status\x18\x01 \x01(\x0e\x32\x31.grpc.health.v1.HealthCheckResponse.ServingStatus\"O\n\rServingStatus\x12\x0b\n\x07UNKNOWN\x10\x00\x12\x0b\n\x07SERVING\x10\x01\x12\x0f\n\x0bNOT_SERVING\x10\x02\x12\x13\n\x0fSERVICE_UNKNOWN\x10\x03\x32Z\n\x06Health\x12P\n\x05\x43heck\x12\".grpc.health.v1.HealthCheckRequest\x1a#.grpc.health.v1.HealthCheckResponseb\x06proto3"

pool = Google::Protobuf::DescriptorPool.generated_pool
pool.add_serialized_file(descriptor_data)

module Grpc
  module Health
    module V1
      HealthCheckRequest = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("grpc.health.v1.HealthCheckRequest").msgclass
      HealthCheckResponse = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("grpc.health.v1.HealthCheckResponse").msgclass
      HealthCheckResponse::ServingStatus = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("grpc.health.v1.HealthCheckResponse.ServingStatus").enummodule
    end
  end
end
