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

# 1) default value is set for attribute
node.default[:my_custom_stuff][:log][:message] = "!!!!set in compile phase!!!!"

# 2) this resource updates the value of the attribute
ruby_block "my_custom_stuff" do
  block do
    # do some stuff...
    # Now save results in node.
    node.set[:my_custom_stuff][:log][:message] = "!!!!set in converge phase!!!!"
  end
end

# 3) lookup log[update_target] from the resource_collection and
#    update the message method with the new attribute value
ruby_block "update_log_message" do
  block do
    log_resource = resources("log[update_target]")
    log_resource.message node[:my_custom_stuff][:log][:message]
  end
end

# 4) this resource *successfully* logs the updated value from step #2
log "update_target" do
  message node[:my_custom_stuff][:log][:message]
end

# Hope that makes sense!

