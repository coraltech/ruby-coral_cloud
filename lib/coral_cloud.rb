
home = File.dirname(__FILE__)

$:.unshift(home) unless
  $:.include?(home) || $:.include?(File.expand_path(home))
  
#-------------------------------------------------------------------------------
  
require 'rubygems'
require 'coral_core'

#---

# Include data model
[ :share, :server, :base ].each do |name| 
  require File.join('coral_cloud', name.to_s + '.rb') 
end

# Include specialized events
Dir.glob(File.join(home, 'coral_cloud', 'event', '*.rb')).each do |file|
  require file
end

#*******************************************************************************
# Coral Cloud / Virtual Machine Management Library
#
# This provides the ability to manage a cloud of servers and sync them with
# associated VMs running on the local machine... 
# (most of this is currently TODO!)
#
# Author::    Adrian Webb (mailto:adrian.webb@coraltech.net)
# License::   GPLv3
module Coral
  
  #-----------------------------------------------------------------------------
  # Constructor / Destructor

  def self.create_cloud(name, options = {})
    return Coral::Cloud.create(name, options)
  end
  
  #---
  
  def self.delete_cloud(name)
    return Coral::Cloud.delete(name)
  end
  
  #-----------------------------------------------------------------------------
  # Accessors / Modifiers
  
  def self.cloud(name)
    return Coral::Cloud[name]
  end

#*******************************************************************************
#*******************************************************************************

module Cloud
  
  VERSION = File.read(File.join(File.dirname(__FILE__), '..', 'VERSION'))
  
  #-----------------------------------------------------------------------------
  # Constructor / Destructor
  
  def self.create(name, options = {})
    return Coral::Cloud::Base.create(name, options)
  end
  
  #---
  
  def self.delete(name) 
    return Coral::Cloud::Base.delete(name)  
  end
  
  #-----------------------------------------------------------------------------
  # Accessors / Modifiers
 
  def self.[](name)
    return Coral::Cloud::Base[name]  
  end
end
end