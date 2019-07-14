class User
  def hi
    @hi = "hi(｡･ω･｡)ノ"
  end
end

def tracer
  TracePoint.trace(:line) do |tp|
    puts "[TP:#{tp.event}] #{tp.path}:#{tp.lineno} #{tp.method_id} #{tp.defined_class}"
    line = File.open(tp.path, "r"){|f| f.readlines[tp.lineno - 1] }
    p node = RubyVM::AbstractSyntaxTree.parse(line)
    pp node
  end
end

tracer
User.new.hi

#=> [TP:line] 04_ast1.rb:3 hi User
#=> #<RubyVM::AbstractSyntaxTree::Node:SCOPE@1:0-1:33>
#=> (SCOPE@1:0-1:33
#=>  tbl: []
#=>  args: nil
#=>  body: (IASGN@1:4-1:33 :@hi (STR@1:10-1:33 "hi(｡･ω･｡)ノ")))
