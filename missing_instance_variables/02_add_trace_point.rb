class User
  def hi
    @hi = "hi(｡･ω･｡)ノ" # 3行目
  end
end

def tracer
  TracePoint.trace(:line) do |tp|
    puts "[TP:#{tp.event}] #{tp.path}:#{tp.lineno} #{tp.method_id} #{tp.defined_class}"
  end
end

tracer
p User.new.hi # 14行目
#=> [TP:line] test.rb:14
#=> [TP:line] test.rb:3 hi User
#=> "hi(｡･ω･｡)ノ"
