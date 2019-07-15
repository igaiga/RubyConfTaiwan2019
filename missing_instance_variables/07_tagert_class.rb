class User
  def hi
    @hi = "hi(｡･ω･｡)ノ"
  end
end

def tracer(target_class_name, target_instance_variable_name)
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
    # Check class
    target_class = Kernel.const_get(target_class_name)
    next unless tp.self.is_a?(target_class)
    puts "[TP:#{tp.event}] #{tp.path}:#{tp.lineno} #{tp.method_id} #{tp.defined_class}"
  end
end

tracer("User", "@hi")
User.new.hi
#=> [TP:line] 07_target_class.rb:3 hi User
