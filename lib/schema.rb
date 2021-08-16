# schema.rb
#   generates `table.sql` from `schema.yaml`
#
# ```console
# $ ruby ../../lib/schema.rb
# ```

require "yaml"

def check_type!(obj, type)
  obj.is_a?(type) or raise "expected #{type}, but got #{obj.class}"
end

def guess_ch_type(key, hash)
  check_type! hash, Hash
  type = hash["type"].to_s

  case type
  when "integer"
    return "Int64"
  when "string", ""
    return "String"
  when "array"
    items = hash["items"] or raise "[items] not found"
    check_type! items, Hash
    type = items["type"].to_s
    case type
    when "string"
      return "Array(String)"
    else
      raise "array(#{type}) is not supported yet. #{items.inspect}"
    end
  else
    raise "unknown type: #{type.inspect}"
  end

rescue => err
  abort "schema error: [#{key}] #{err}"
end

hash = YAML.load(File.read("schema.yaml"))
check_type! hash, Hash
hash.size == 1   or abort "schema error: expected size=1, but got #{hash.size}"
schema_name  = hash.keys.first   or abort "BUG: hash[0] is nil"
schema_value = hash.values.first or abort "BUG: hash[0] is nil"

properties = schema_value["properties"] or
  abort "schema error: no properties"

properties.is_a?(Hash) or
  abort "schema error: properties expected Hash, but got #{properties.class}"

name_and_types = []
properties.each do |k,v|
  type = guess_ch_type(k, v)
  name_and_types << [k, type]
end

table_name = schema_name.sub(/Service.*$/, "")
puts "CREATE TABLE IF NOT EXISTS #{table_name} ("
name_and_types.each_with_index do |(name, type), i|
  cj = (i == name_and_types.size - 1) ? "" : ","
  puts "  #{name} #{type}#{cj}"
end
puts ") Engine = Log"

