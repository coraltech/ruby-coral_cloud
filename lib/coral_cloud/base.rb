
module Coral
module Cloud
class Base < Memory

  #-----------------------------------------------------------------------------
  # Properties
  
  @@instances = {}
  
  #-----------------------------------------------------------------------------
  # Constructor / Destructor
  
  def self.create(name, options = {})
    options[:name]    = name unless options.has_key?(:name)
    @@instances[name] = new(options) 
    return @@instances[name]  
  end
  
  #---
  
  def self.delete(name) 
    if @@instances.has_key?(name) && @@instances[name]
      @@instances.delete(name) 
    end  
  end
  
  #-----------------------------------------------------------------------------
 
  def self.[](name)
    if ! @@instances.has_key?(name) || ! @@instances[name]
      @@instances[name] = new({ :name => name })
    end  
    return @@instances[name]  
  end
  
  #-----------------------------------------------------------------------------
  
  def initialize(options = {})
    super(options)
    
    @repositories = {}
    @shares       = {}
    @servers      = {}
  end
      
  #-----------------------------------------------------------------------------
  # Property accessors / modifiers
    
  def repositories(reset = false)
    if reset || @repositories.empty?
      @repositories = {}
      get('repositories', {}, :hash).each do |submodule, remote_dir|
        @repositories[submodule] = Coral::Repository.new({
          :name       => submodule,
          :directory  => @directory,
          :submodule  => submodule,
          :remote_dir => remote_dir,
        })
      end
    end
    return @repositories
  end
    
  #---
    
  def set_repositories(values = {})
    return set('repositories', values)
  end
     
  #---
    
  def repository(local_repo, default = '', format = false)
    return get_group('repositories', local_repo, nil, default, format)
  end
    
  #---
    
  def set_repository(local_repo, remote_repo)
    return set_group('repositories', local_repo, nil, remote_repo)
  end
    
  #---
    
  def delete_repository(local_repo)
    return delete_group('repositories', local_repo, nil)
  end
     
  #-----------------------------------------------------------------------------
  
  def settings(group)
    return get_group('settings', group, nil, {}, :hash)
  end
    
  #---

  def set_settings(group, values = {})
    return set_group('settings', group, nil, values)
  end
    
  #---

  def delete_settings(group)
    return delete_group('settings', group, nil)
  end
    
  #---
   
  def setting(group, key, default = '', format = false)
    return get_group('settings', group, key, default, format)
  end
     
  #---

  def set_setting(group, key, value = '')
    return set_group('settings', group, key, value)
  end
     
  #---

  def delete_setting(group, key)
    return delete_group('settings', group, key)
  end
      
  #-----------------------------------------------------------------------------
    
  def shares(reset = false)
    if reset || @shares.empty?
      @shares = {}
      get('shares', {}, :hash).each do |name, share_info|
        share_info = Coral::Util::Data.merge([ {
          :name      => name,
          :directory => File.join(@directory, share_info['local_dir']),
        }, symbol_map(share_info) ])
        
        @shares[name] = Coral::Cloud::Share.new(share_info)
      end
    end
    return @shares
  end
    
  #---

  def set_shares(values = {})
    return set('shares', values)
  end
 
  #---
    
  def share(name, key = nil, default = {}, format = false)
    return get_group('shares', name, key, default, format)
  end
    
  #---

  def set_share(name, key = nil, value = {})
    return set_group('shares', name, key, value)
  end
    
  #---

  def delete_share(name, key = nil)
    return delete_group('shares', name, key)
  end
    
  #-----------------------------------------------------------------------------
    
  def servers(reset = false)
    if reset || @servers.empty?
      @servers = {}
      get('servers', {}, :hash).each do |name, server_info|
        server_info = Coral::Util::Data.merge([ {
          :cloud   => self,
          :machine => name,
        }, symbol_map(server_info) ])
        
        @servers[name] = Coral::Cloud::Server.new(server_info)
      end
    end
    return @servers
  end
    
  #---

  def set_servers(values = {})
    return set('servers', values)
  end

  #---
    
  def server(name, key = nil, default = {}, format = false)
    return get_group('servers', name, key, default, format)
  end
    
  #---

  def set_server(name, key = nil, value = {})
    return set_group('servers', name, key, value)
  end
    
  #---

  def delete_server(name, key = nil)
    return delete_group('servers', name, key)
  end
    
  #-----------------------------------------------------------------------------
     
  def search(server, key, default = '', format = false)
    value       = default
    server_info = server(server)
    
    if server_info[key]
      value = server_info[key]
    else
      settings = {}
      if server_info.has_key?('settings')
        array(server_info['settings']).each do |group|
          settings = settings(group)
        
          if settings.has_key?(key)
            if value.is_a?(Array) && settings[key].is_a?(Array)
              value = value | settings[key]
            else
              value = settings[key]  
            end            
            break
          end
        end      
      end
    end
    return filter(value, format)
  end
end
end
end