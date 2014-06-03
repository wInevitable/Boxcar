require 'uri'
require 'debugger'

class Params
  # use your initialize to merge params from
  # 1. query string
  # 2. post body
  # 3. route params
  def initialize(req, route_params = {})
    @req = req
    @route_params = {}
    @params = {} #hash of params keys and values
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
    
  end

  class AttributeNotFoundError < ArgumentError; end;

##  #private
  # this should return deeply nested hash
  # argument format
  # user[address][street]=main&user[address][zip]=89436
  # should return
  # { "user" => { "address" => { "street" => "main", "zip" => "89436" } } }
  def parse_www_encoded_form(www_encoded_form)
    #parse URI-encoded string
    #set keys and values in @params
    result = URI::decode_www_form(www_encoded_form)
    debugger
    @params = result.map do |pair|
      keys = parse_key(pair[0])
      value = pair[1]
      
      rec_builder(keys, value)
    end
  end
  
  def rec_builder(array, value)
    hash = {}
    if array.count = 1 #base case, last key sets to value
      hash[array[0]] = value
    else #shift out first key and set to a value of a recursive call
      hash[array.shift] = rec_builder(array, value)
    end
    hash
  end

  # this should return an array
  # user[address][street] should return ['user', 'address', 'street']
  def parse_key(keys)
    keys.tr("^a-zA-Z0-9 ", " ").squeeze(" ").strip.split(" ")
  end
end
