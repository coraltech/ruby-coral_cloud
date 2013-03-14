
module Coral
module Cloud
class Server < Core
    
  #-----------------------------------------------------------------------------
  # Constructor / Destructor
  
  def initialize(options = {})
    super(options)
    
    self.machine = ( options.has_key?(:machine) ? options[:machine] : '' )    
    @cloud       = ( options.has_key?(:cloud) ? options[:cloud] : Coral.create_cloud(@name, options) )    
  end
   
  #-----------------------------------------------------------------------------
  # Property accessors / modifiers
  
  attr_reader :machine, :name, :cloud

  #---
 
  def machine=machine
    @name = ''
    if machine.is_a?(String)
      @machine = nil
      @name    = machine
    else
      @machine = machine
      @name    = @machine.name if @machine
    end
  end
 
  #---
  
  def hostname
    return @cloud.server(@name, 'hostname', '', :string)
  end

  #---
   
  def hostname=hostname
    @cloud.set_server(@name, 'hostname', hostname)
  end
 
  #---
  
  def public_ip
    return @cloud.server(@name, 'public_ip', '', :string)
  end

  #---
   
  def public_ip=public_ip
    @cloud.set_server(@name, 'public_ip', public_ip)
  end
 
  #---
  
  def internal_ip
    return @cloud.server(@name, 'internal_ip', '', :string)
  end

  #---
   
  def internal_ip=internal_ip
    @cloud.set_server(@name, 'internal_ip', internal_ip)
  end
 
  #---
  
  def virtual_hostname
    return @cloud.search(@name, 'virtual_hostname', '', :string)
  end

  #---
   
  def virtual_hostname=virtual_hostname
    @cloud.set_server(@name, 'virtual_hostname', virtual_hostname)
  end
  
  #---
  
  def virtual_ip
    return @cloud.search(@name, 'virtual_ip', '', :string)
  end

  #---
   
  def virtual_ip=virtual_ip
    @cloud.set_server(@name, 'virtual_ip', virtual_ip)
  end
  
  #-----------------------------------------------------------------------------
     
  def repositories(options = {}, return_objects = true)
    repositories = array(options[:repos], @cloud.repositories.keys, true)
    results      = ( return_objects ? {} : [] )    
    
    return results unless repositories.is_a?(Array)
    
    repositories.each do |repo_name|
      if @cloud.repositories.has_key?(repo_name)
        if return_objects
          results[repo_name] = @cloud.repositories[repo_name]
        else
          results << repo_name
        end
      end
    end
    return results
  end
  
  #---
  
  def shares(options = {}, return_objects = true)
    shares  = array(options[:shares], @cloud.shares.keys, true)
    results = ( return_objects ? {} : [] )    
    
    return results unless shares.is_a?(Array)
    
    shares.each do |share_name|
      if @cloud.shares.has_key?(share_name)
        if return_objects
          results[share_name] = @cloud.shares[share_name]
        else
          results << share_name
        end
      end
    end
    return results
  end
            
  #-----------------------------------------------------------------------------
  # Management 
    
  def start(options = {})
    sync_remotes(options)
        
    return true if ! @machine
    
    options["provision.enabled"] = false
    
    if @machine.created?
      @machine.start(options)
    else
      @machine.up(options)
    end
    return true
  end
    
  #-----------------------------------------------------------------------------
  
  def update(options = {})
    sync_remotes(options)
    
    success = true    
    return success if ! @machine    
    
    if @machine.created?
      if @machine.state == :running
        success = Coral::Command.new("vagrant provision #{@name}").exec!(options) do |line|
          process_puppet_message(line)
        end    
      end
    end
    return success   
  end
    
  #-----------------------------------------------------------------------------

  def destroy(options = {})    
    return true if ! @machine
    
    if @machine.created?
      do_destroy = false

      if options[:force]
        do_destroy = true
      else
        choice = nil
        begin
          choice = ui.ask("Are you sure you want to remove: #{@name}?")
        rescue Errors::UIExpectsTTY
        end
        do_destroy = choice.upcase == "Y"
      end

      if do_destroy
        @machine.destroy
      end
    end
    return true    
  end
  
  #-----------------------------------------------------------------------------
  # Repository operations
  
  def sync_remotes(options = {})
    repositories(options).each do |repo_name, repo|
      if repo.can_persist?
        if @name != 'all'
          repo.set_remote(@name, public_ip, options)
        end        
        
        server_ips = []      
        @cloud.servers.each do |server_name, server|
          server_ips << server.public_ip
        end
        
        options[:add] = true
        repo.set_remote('all', server_ips, options)
      end
    end
    return true
  end
  
  #-----------------------------------------------------------------------------
  
  def commit(options = {})    
    repositories(options).each do |name, repo|
      if repo.can_persist?
        repo.commit('.', options)
      end      
    end
    return true    
  end
  
  #-----------------------------------------------------------------------------
  
  def push(options = {})  
    sync_remotes(options)
       
    success = true
    repositories(options).each do |name, repo|
      if repo.can_persist?
        success = repo.push!(@name, options) do |line|
          process_puppet_message(line)  
        end
        break unless success
      end
    end
    return success
  end
  
  #-----------------------------------------------------------------------------
  # Utilities
  
  def process_puppet_message(line)
    return line.match(/err:\s+/) ? { :success => false, :prefix => 'FAIL' } : true
  end
end
end
end