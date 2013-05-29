#
# Cookbook Name:: attr-update
# Recipe:: default
#
# Copyright (C) 2013 caryp
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Here is a simplified example of how one can "pass" node attributes from one
# resource to another during the Chef converge phase.
#
# In this recipe we have a custom ruby_block[my_custom_stuff] that dynamically
# sets an attribute that we want the log[update_target] resource to output to
# the Chef log.
#
# To do this we use a third "update" resource, ruby_block[update_log_message],
# which will lookup log[update_target] from the resource_collection and update
# it with our new attribute value.
#
# NOTE: this is a simplified example for illustrative purposes only.
#       Always make sure your ruby_blocks have proper idempotency checks.
#

# Here is my custom ruby_block that dynamically updates the
# my_custom_stuff/log/message attribute, then fires off a notification to
# the next resource, ruby_block[update_log_message].
ruby_block "my_custom_stuff" do
  block do
    # do some stuff...

    # Now save results in node.
    node.set[:my_custom_stuff][:log][:message] = "!!!!set in converge phase!!!!"
  end
  notifies :create, "ruby_block[update_log_message]", :immediately
end

# This ruby_block is a helper that does the wiring between my custom
# resource above and the generic log resource below.
#
# It does so by manipulating the resource_collection directly
ruby_block "update_log_message" do
  block do
    log_resource = run_context.resource_collection.lookup("log[update_target]")
    log_resource.message node[:my_custom_stuff][:log][:message]
  end
  action :nothing
end

# this is the log resource that get's updated dynamically at converge time
log "update_target" do
  message node[:my_custom_stuff][:log][:message]
end

# this log resource only gets updated at compile time.
log "not a target" do
  message node[:my_custom_stuff][:log][:message]
end

# Hope that makes sense!

