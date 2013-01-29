
module Coral
module Cloud
class Share < Core
    
  #-----------------------------------------------------------------------------
  # Constructor / Destructor
  
  def initialize(options = {})
    super(options)
    
    @name          = ( options.has_key?(:name) ? string(options[:name]) : '' )
    @remote_dir    = ( options.has_key?(:remote_dir) ? string(options[:remote_dir]) : '' )
      
    self.directory = ( options.has_key?(:directory) ? string(options[:directory]) : '' )
  end
   
  #-----------------------------------------------------------------------------
  # Property accessors / modifiers
  
  attr_accessor :name, :remote_dir
  attr_reader :directory

  #---
  
  def directory=directory
    @directory = string(directory)
    ensure_directory
  end
  
  #-----------------------------------------------------------------------------
     
  def ensure_directory
    unless @directory.empty?
      # @TODO: This is not OS agnostic.
      if ! File.directory?(@directory) && system("which mkdir 2>1 1>/dev/null")
        system("sudo mkdir -p #{@directory}")
      end
    end
    return self
  end
end
end
end