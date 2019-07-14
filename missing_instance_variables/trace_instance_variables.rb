# 完成版
class User
  def hi
    @hi = "hi(｡･ω･｡)ノ"
  end
end

def tracer(target_class_name, target_instance_variable_name)
  TracePoint.trace(:line) do |tp|
    # ソース取得
    begin
      line = File.open(tp.path, "r"){|f| f.readlines[tp.lineno - 1] }
    rescue Errno::ENOENT => e
    end
    next unless line
    # AST取得
    begin
      node = RubyVM::AbstractSyntaxTree.parse(line).children.last
    rescue Exception => e # 乱暴
      next
    end
    # インスタンス変数への代入かを調べる
    next unless node.type == :IASGN
    # クラス名を調べる
    target_class = Kernel.const_get(target_class_name)
    next unless tp.self.is_a?(target_class)
    # インスタンス変数名を調べる
    instance_variable_name = node.children.first
    next unless instance_variable_name == target_instance_variable_name.to_sym
    puts "#{target_class_name} #{target_instance_variable_name} is assigned in #{tp.path}:#{tp.lineno} #{tp.method_id} #{tp.defined_class}"
  end
end

tracer("User", "@hi")
User.new.hi
#=> User @hi is assigned in trace_instance_variables.rb:4 hi User
