class User
  def hi
    @hi = "hi(｡･ω･｡)ノ"
  end
end

def tracer
  TracePoint.trace(:line) do |tp|
    puts "[TP:#{tp.event}] #{tp.path}:#{tp.lineno} #{tp.method_id} #{tp.defined_class}"
    p line = File.open(tp.path, "r"){|f| f.readlines[tp.lineno - 1] } 
  end
end

tracer
p User.new.hi
#=> [TP:line] test.rb:15
#=> "p User.new.hi\n"
#=> [TP:line] test.rb:3 hi User
#=> "    @hi = \"hi(｡･ω･｡)ノ\"\n"
#=> "hi(｡･ω･｡)ノ"
