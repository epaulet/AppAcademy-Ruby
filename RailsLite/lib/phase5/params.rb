require 'uri'

module Phase5
  class Params
    # use your initialize to merge params from
    # 1. query string
    # 2. post body
    # 3. route params
    #
    # You haven't done routing yet; but assume route params will be
    # passed in as a hash to `Params.new` as below:
    def initialize(req, route_params = {})
      query_string_params = parse_www_encoded_form(req.query_string)
      body_params = parse_www_encoded_form(req.body)

      @params = query_string_params.merge(body_params).merge(route_params)
    end

    def [](key)
      @params[key.to_s]
    end

    def to_s
      @params.to_json.to_s
    end

    class AttributeNotFoundError < ArgumentError; end;

    private
    # this should return deeply nested hash
    # argument format
    # user[address][street]=main&user[address][zip]=89436
    # should return
    # { "user" => { "address" => { "street" => "main", "zip" => "89436" } } }
    def parse_www_encoded_form(www_encoded_form)
      return {} unless www_encoded_form

      decoded_params = URI::decode_www_form(www_encoded_form)
      flattened_params = flatten_params(decoded_params)

      params_hash = {}
      flattened_params.each do |params_array|
        temp_hash = nest_params(params_array)
        params_hash = deep_merge_hashes(params_hash, temp_hash)
      end

      params_hash
    end


    # Come back and try using tree node solution instead
    def deep_merge_hashes(a,b)
      a.merge(b) do |key, old_value, new_value|
        if old_value.is_a?(Hash) && new_value.is_a?(Hash)
          deep_merge_hashes(old_value, new_value)
        else
          new_value
        end
      end
    end

    def nest_params(params_array)
      temp_hash = {}
      value = params_array.pop
      key = params_array.pop
      temp_hash[key] = value

      until params_array.empty?
        sub_hash = {}
        key = params_array.pop
        sub_hash[key] = temp_hash
        temp_hash = sub_hash
      end

      temp_hash
    end

    def flatten_params(nested_params)
      nested_params.map do |pair|
        key = pair[0]
        value = pair[1]
        keys = parse_key(key)
        keys << value
      end
    end


    # this should return an array
    # user[address][street] should return ['user', 'address', 'street']
    def parse_key(key)
      keys = key.split(/\]\[|\[|\]/)
      keys = [keys] unless keys.is_a?(Array)
      keys
    end
  end
end
