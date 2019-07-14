class User
  def hi
    @hi = "hi(｡･ω･｡)ノ"
  end
end

def tracer(target_class_name)
  TracePoint.trace(:line) do |tp|
    # Get source code
    line = File.open(tp.path, "r"){|f| f.readlines[tp.lineno - 1] }
    # Get AST
    node = RubyVM::AbstractSyntaxTree.parse(line).children.last
    # Check the AST is instance variable assignment
    next unless node.type == :IASGN
    # Check class
    target_class = Kernel.const_get(target_class_name)
    next unless tp.self.is_a?(target_class)
    puts "[TP:#{tp.event}] #{tp.path}:#{tp.lineno} #{tp.method_id} #{tp.defined_class}"
  end
end

tracer("User")
User.new.hi
#=> [TP:line] 05_ast2.rb:3 hi User
