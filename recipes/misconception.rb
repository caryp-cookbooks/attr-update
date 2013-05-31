#
# Cookbook Name:: attr-update
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

# Here is how someone new to Chef might think things work.

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

# 3) this resource should log the updated value from step #2
log "update_target" do
  message node[:my_custom_stuff][:log][:message]
end

# However, this unfortunatly logs "!!!!set in compile phase!!!!".
# Why? All resource attributes are evaluated in the "compile" phase -- almost
# like a "pre-processor" step in C.   In other words, the attribute values for
# each resource were already set before the recipe even started to execute.
#
# This can be a little hard to get your head around if you are just learning
# Chef.  For more information about the "compile" phase see Anatomy of a Chef
# Run: http://wiki.opscode.com/display/ChefCN/Anatomy+of+a+Chef+Run
#
# See default.rb for a way to achive the desired results


