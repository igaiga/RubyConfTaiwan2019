def tracer(target_instance_variable_name)
  TracePoint.trace(:line) do |tp|
    # Get source code
    begin
      line = File.open(tp.path, "r"){|f| f.readlines[tp.lineno - 1] }
    rescue Errno::ENOENT => _e
    end
    next unless line
    # Adopt to erb
    if match_data = line.match(/\A\s*<%=*(.*)%>\s*\z/)
      line = match_data.captures.first
    end
    # Get AST
    begin
      node = RubyVM::AbstractSyntaxTree.parse(line).children.last
    rescue SyntaxError => _e
      next
    end
    # Check the AST is instance variable assignment
    next unless node.type == :IASGN
    # Check instance variable name
    instance_variable_name = node.children.first
    next unless instance_variable_name == target_instance_variable_name.to_sym
    puts "#{target_instance_variable_name} is assigned in #{tp.path}:#{tp.lineno} #{tp.method_id} #{tp.defined_class}"
  end
end

tracer("@books")
