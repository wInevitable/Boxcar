require 'uri'
require 'debugger'

class Params
  # use your initialize to merge params from
  # 1. query string
  # 2. post body
  # 3. route params
  def initialize(req, route_params = {})
    @req = req
    #hash of params keys and values
    @params = req.query_string.nil? ? {} : parse_www_encoded_form(req.query_string)
    @params = @params.merge(parse_www_encoded_form(req.body)) unless req.body.nil?
  end

  def [](key)
    @params[key]
  end

  def permit(*keys)
  end

  def require(key)
  end

  def permitted?(key)
  end

  def to_s
    @params.to_s
  end

  class AttributeNotFoundError < ArgumentError; end;

##  #private
  # this should return deeply nested hash
  # argument format
  # "user[address][street]=main&user[address][zip]=89436"
  # should return
  # { "user" => { "address" => { "street" => "main", "zip" => "89436" } } }
  def parse_www_encoded_form(www_encoded_form)
    #parse URI-encoded string
    #set keys and values in @params
    result = URI.decode_www_form(www_encoded_form)
    new_hash = {}
    
    result.each do |keys, value|
      keys = parse_key(keys)
      key_hash = {}
      while keys.any?
        val = key_hash.empty? ? value : key_hash
        key_hash = { keys.pop => val }
      end

      if new_hash.empty?
        new_hash = key_hash
      else
        new_hash = deep_merge(new_hash, key_hash)
      end
    end
    
    new_hash
  end
  
  def deep_merge(hash1, hash2)
    merged_hash = {}
    
    if hash1.first[1].is_a?(Hash) #deep merge, recursive call
      merged_hash[hash1.first[0]] = deep_merge(hash1.first[1], hash2.first[1])
    else #shallow merge, base case
      merged_hash = hash1.merge(hash2)
    end
    
    merged_hash
  end

  #old code for nostalgia purposes
  def rec_builder(array, value)
    hash = {}

    if array.count == 1 #base case, last key sets to value
      hash[array[0]] = value
    else #shift out first key and set to a value of a recursive call
      hash[array.shift] = rec_builder(array, value)
    end
    hash
  end
  #end old code

  # this should return an array
  # user[address][street] should return ['user', 'address', 'street']
  def parse_key(keys)
    keys.tr("^a-zA-Z0-9 ", " ").squeeze(" ").strip.split(" ")
  end
end
