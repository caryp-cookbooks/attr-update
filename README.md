# attr-update cookbook

An example of how to "pass" an attribute value from one resource to another.

# Usage

Take a look at the annotated ```recipes/default.rb``` file for explanation of
the pattern.

You can also play with the code yourself:

    git clone git://github.com/caryp-cookbooks/attr-update.git
    cd attr-update
    bundle install
    bundle exec vagrant up

# Attributes

```node[:my_custom_stuff][:log][:message]``` : this is what we use to pass a value from one resource to another.

# Requirements

To play with the code you'll need:
 * Chef 10.18.0+
 * Vagrant 1.1+
 * vagrant-berkshelf plugin
 * Bundler

# Author

Author:: caryp (<cary@rightscale.com>)
