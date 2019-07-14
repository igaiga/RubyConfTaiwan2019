# Complete version
class User
  def hi
    @hi = "hi(｡･ω･｡)ノ"
  end
end

def tracer(target_class_name, target_instance_variable_name)
  TracePoint.trace(:line) do |tp|
    # Get source code
    begin
      line = File.open(tp.path, "r"){|f| f.readlines[tp.lineno - 1] }
    rescue Errno::ENOENT => e
    end
    next unless line
    # Get AST
    begin
      node = RubyVM::AbstractSyntaxTree.parse(line).children.last
    rescue Exception => e # too bad
      next
    end
    # Check AST is instance variable assignment
    next unless node.type == :IASGN
    # Check class name
    target_class = Kernel.const_get(target_class_name)
    next unless tp.self.is_a?(target_class)
    # Check instance variable name
    instance_variable_name = node.children.first
    next unless instance_variable_name == target_instance_variable_name.to_sym
    puts "#{target_class_name} #{target_instance_variable_name} is assigned in #{tp.path}:#{tp.lineno} #{tp.method_id} #{tp.defined_class}"
  end
end

tracer("User", "@hi")
User.new.hi
#=> User @hi is assigned in trace_instance_variables.rb:4 hi User
