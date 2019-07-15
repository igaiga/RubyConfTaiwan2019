class User
  def hi
    @hi = "hi(｡･ω･｡)ノ"
  end
end

def tracer(target_instance_variable_name)
  TracePoint.trace(:line) do |tp|
    # Get source code
    line = File.open(tp.path, "r"){|f| f.readlines[tp.lineno - 1] }
    # Get AST
    node = RubyVM::AbstractSyntaxTree.parse(line).children.last
    # Check the AST is instance variable assignment
    next unless node.type == :IASGN
    # Check instance variable name
    instance_variable_name = node.children.first
    next unless instance_variable_name == target_instance_variable_name.to_sym
    puts "[TP:#{tp.event}] #{tp.path}:#{tp.lineno} #{tp.method_id} #{tp.defined_class}"
  end
end

tracer("@hi")
User.new.hi
#=> [TP:line] 06_target_name.rb:3 hi User
