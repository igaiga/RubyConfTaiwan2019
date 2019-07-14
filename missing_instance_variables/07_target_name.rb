class User
  def hi
    @hi = "hi(｡･ω･｡)ノ"
  end
end

def tracer(target_class_name, target_instance_variable_name)
  TracePoint.trace(:line) do |tp|
    # ソース取得
    line = File.open(tp.path, "r"){|f| f.readlines[tp.lineno - 1] }
    # AST取得
    node = RubyVM::AbstractSyntaxTree.parse(line).children.last
    # インスタンス変数への代入かを調べる
    next unless node.type == :IASGN
    # クラス名を調べる
    target_class = Kernel.const_get(target_class_name)
    next unless tp.self.is_a?(target_class)
    # インスタンス変数名を調べる
    instance_variable_name = node.children.first
    next unless instance_variable_name == target_instance_variable_name.to_sym
    puts "[TP:#{tp.event}] #{tp.path}:#{tp.lineno} #{tp.method_id} #{tp.defined_class}"
  end
end

tracer("User", "@hi")
User.new.hi
#=> [TP:line] 07_ast4.rb:3 hi User
