class User
  def hi
    @hi = "hi(｡･ω･｡)ノ"
  end
end

def tracer
  TracePoint.trace(:line) do |tp|
    # ソース取得
    line = File.open(tp.path, "r"){|f| f.readlines[tp.lineno - 1] }
    # AST取得
    node = RubyVM::AbstractSyntaxTree.parse(line).children.last
    # インスタンス変数への代入かを調べる
    next unless node.type == :IASGN
    puts "[TP:#{tp.event}] #{tp.path}:#{tp.lineno} #{tp.method_id} #{tp.defined_class}"
  end
end

tracer
User.new.hi
#=> [TP:line] 05_ast2.rb:3 hi User
