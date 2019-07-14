class User
  def hi
    @hi = "hi(｡･ω･｡)ノ"
  end
end

def tracer
  TracePoint.trace(:line) do |tp|
    # Get source code
    line = File.open(tp.path, "r"){|f| f.readlines[tp.lineno - 1] }
    # Get AST
    node = RubyVM::AbstractSyntaxTree.parse(line).children.last
    # Check the AST is instance variable assignment
    next unless node.type == :IASGN
    puts "[TP:#{tp.event}] #{tp.path}:#{tp.lineno} #{tp.method_id} #{tp.defined_class}"
  end
end

tracer
User.new.hi
#=> [TP:line] 05_ast2.rb:3 hi User
