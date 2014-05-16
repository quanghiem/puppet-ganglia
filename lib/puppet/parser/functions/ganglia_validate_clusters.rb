module Puppet::Parser::Functions

  newfunction(:ganglia_validate_clusters, :doc => <<-'ENDHEREDOC') do |args|
    The following values will pass:

    The following values will fail, causing compilation to abort:

    ENDHEREDOC

    Puppet::Parser::Functions.autoloader.loadall

    # we accept only one arg
    unless args.length == 1 then
      raise Puppet::ParseError, ("ganglia_validate_clusters(): wrong number of arguments (#{args.length}; must be 1)")
    end

    # which must be an array
    function_validate_array(args)

    # that is not empty
    clusters = args[0]
    unless clusters.length > 0
      raise Puppet::ParseError, ("ganglia_validate_clusters(): passed Array may not be empty")
    end

    # which must contain only Hashes
    clusters.each do |c|
      function_validate_hash([c])

      # that are not empty
      unless c.length > 0
        raise Puppet::ParseError, ("ganglia_validate_clusters(): nested Hash may not be empty")
      end

      # and must contain the name key
      unless c.has_key?('name')
        raise Puppet::ParseError, ("ganglia_validate_clusters(): nested Hash must contain a name key")
      end
      # which is a string
      unless c['name'].is_a?(String) 
        raise Puppet::ParseError, ("ganglia_validate_clusters(): nested Hash name key must be a String")
      end

      # and must contain the address key
      unless c.has_key?('address')
        raise Puppet::ParseError, ("ganglia_validate_clusters(): nested Hash must contain an address key")
      end
      # which is a string or an array
      unless c['address'].is_a?(String) || c['address'].is_a?(Array)
        raise Puppet::ParseError, ("ganglia_validate_clusters(): nested Hash address key must be a String or Array")
      end

      # if the optional polling_interval key is set
      if c.has_key?('polling_interval')
        # it must be a string (int really)
        unless c['polling_interval'].is_a?(String) || c['polling_interval'].is_a?(Integer)
          raise Puppet::ParseError, ("ganglia_validate_clusters(): nested Hash polling_interval key must be a String or Integer")
        end
      end

      # any other keys should be rejected
      extras = c.keys - %w{ name address polling_interval }
      if extras.length > 0
        raise Puppet::ParseError, ("ganglia_validate_clusters(): nested Hash contains unknown keys (#{extras.sort})") 
      end
    end
  end

end
