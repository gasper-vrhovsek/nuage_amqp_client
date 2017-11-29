#--
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.
#++

require 'mqlight'

class NuageMqLightClient

  def initialize(topics, opts)
    @topics = topics
    @opts = opts

    opts[:id]       = ENV["MQLIGHT_ID"]
    opts[:url]      = ENV["MQLIGHT_URL"]
    opts[:user]     = ENV["MQLIGHT_USER"]
    opts[:password] = ENV["MQLIGHT_PASS"]
    opts[:port]     = ENV["MQLIGHT_PORT"]

    puts "INIT opts: #{opts}"

    client = Mqlight::BlockingClient.new("amqp://#{opts[:url]}:#{opts[:port]}", opts)
    puts "Client done #{client.to_s}"
    # client.subscribe("topic/CNAAlarms")
    client.subscribe("CNAMessages")
    puts "Client subscribed"
    delivery = client.receive("CNAMessages")
    puts "Delivery: #{delivery.data}"
    # delivery = client.receive("topic/CNAAlarms")
    puts delivery.data
  rescue Exception => e
    puts "Exception thrown: #{e.to_s}"
    raise e
  end
end

urls = [ENV['NUAGE_AMQP']]


NuageMqLightClient.new(["topic/CNAMessages", "topic/CNAAlarms"], options)

# loop do
#   begin
#     hw = NuageMqLightClient.new(["topic/CNAMessages", "topic/CNAAlarms"], options)
#
#   rescue => e
#     puts "Caught exception #{e}"
#   end
#
#   sleep 2
# end