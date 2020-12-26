require "helper"
require "fluent-plugin-s3-arrow/schemas"

class AWSGlueTest < Test::Unit::TestCase
    def setup
      stub(Aws::Glue::Client).new
      @schema = FluentPluginS3Arrow::Schemas::AWSGlue.new('test')
    end

    
    def test_to_arrow
      stub(@schema).fetch_glue_schema{
        [
          Aws::Glue::Types::Column.new({name: "a", type: "boolean"}),
          Aws::Glue::Types::Column.new({name: "b", type: "tinyint"}),
          Aws::Glue::Types::Column.new({name: "c", type: "smallint"}),
          Aws::Glue::Types::Column.new({name: "d", type: "int"}),
          Aws::Glue::Types::Column.new({name: "e", type: "bigint"}),
          Aws::Glue::Types::Column.new({name: "f", type: "float"}),
          Aws::Glue::Types::Column.new({name: "g", type: "double"}),
          Aws::Glue::Types::Column.new({name: "h", type: "char(1)"}),
          Aws::Glue::Types::Column.new({name: "i", type: "varchar(1)"}),
          Aws::Glue::Types::Column.new({name: "j", type: "string"}),
          Aws::Glue::Types::Column.new({name: "k", type: "binary"}),
          Aws::Glue::Types::Column.new({name: "l", type: "date"}),
          Aws::Glue::Types::Column.new({name: "m", type: "array<array<string>>"}),
          Aws::Glue::Types::Column.new({name: "n", type: "struct<p1:string,p2:struct<c1:string,c2:string>,p3:string>"})
        ]
      }
      actual = @schema.to_arrow
      expect = [
        {name: "a", type: "boolean"},
        {name: "b", type: "int8"},
        {name: "c", type: "int16"},
        {name: "d", type: "int32"},
        {name: "e", type: "int64"},
        {name: "f", type: "float"},
        {name: "g", type: "double"},
        {name: "h", type: "string"},
        {name: "i", type: "string"},
        {name: "j", type: "string"},
        {name: "k", type: "binary"},
        {name: "l", type: "date32"},
        {name: "m", type: "list", field: {name: "", type: "list", field: {name: "", type: "string"}}},
        {name: "n", type: "struct", fields: [{name: "p1", type: "string"},{name: "p2", type: "struct", fields: [{name: "c1", type: "string"},{name: "c2", type: "string"}]},{name: "p3", type: "string"}]}
      ]
      
      assert_equal expect, actual
      assert_nothing_raised("Invalid arrow schema: #{actual}") { Arrow::Schema.new(actual) }
      
    end
end
