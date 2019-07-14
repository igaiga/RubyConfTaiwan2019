def tracer(target_instance_variable_name)
  TracePoint.trace(:line) do |tp|
    # ソース取得
    begin
      line = File.open(tp.path, "r"){|f| f.readlines[tp.lineno - 1] }
    rescue Errno::ENOENT => _e
    end
    next unless line
    # erb対応
    if match_data = line.match(/\A\s*<%=*(.*)%>\s*\z/)
      line = match_data.captures.first
    end
    # AST取得
    begin
      node = RubyVM::AbstractSyntaxTree.parse(line).children.last
    rescue SyntaxError => _e
      next
    end
    # インスタンス変数への代入かを調べる
    next unless node.type == :IASGN
    # インスタンス変数名を調べる
    instance_variable_name = node.children.first
    next unless instance_variable_name == target_instance_variable_name.to_sym
    puts "#{target_instance_variable_name} is assigned in #{tp.path}:#{tp.lineno} #{tp.method_id} #{tp.defined_class}"
  end
end

tracer("@books")
