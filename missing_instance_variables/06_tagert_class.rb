class User
  def hi
    @hi = "hi(｡･ω･｡)ノ"
  end
end

def tracer(target_class_name)
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
    puts "[TP:#{tp.event}] #{tp.path}:#{tp.lineno} #{tp.method_id} #{tp.defined_class}"
  end
end

tracer("User")
User.new.hi
#=> [TP:line] 05_ast2.rb:3 hi User
