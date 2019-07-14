class User
  def hi
    @hi = "hi(｡･ω･｡)ノ" # line:3
  end
end

def tracer
  TracePoint.trace(:line) do |tp|
    puts "[TP:#{tp.event}] #{tp.path}:#{tp.lineno} #{tp.method_id} #{tp.defined_class}"
  end
end

tracer
p User.new.hi # line:14
#=> [TP:line] test.rb:14
#=> [TP:line] test.rb:3 hi User
#=> "hi(｡･ω･｡)ノ"
