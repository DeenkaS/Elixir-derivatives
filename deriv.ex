defmodule Deriv do
  @type literal() :: {:num, number()} | {:var, atom()}
  @type expr() :: literal() | {:add, expr(),expr()} | {:mul, expr(),expr()} |
 {:div,expr(),expr()} | {:pow,expr(),literal()} | {:sqrt,expr()} | {:trig, expr(),expr()}


 def deriv({:num,_},_) do {:num,0} end
 def deriv({:var,x},x) do {:num,1} end
 def deriv({:var,_},_) do {:num,0} end
 def deriv({:add,e1,e2},x) do {:add,deriv(e1,x),deriv(e2,x)} end
 def deriv({:mul,e1,e2},x) do {:add,{:mul,deriv(e1,x),e2},{:mul,e1,deriv(e2,x)}} end
 def deriv({:ln,x},x) do {:mul,{:div,1,x},deriv(x,x)}  end
 def deriv({:div,a,x},x) do {:div,{:num,-a},{:pow,x,2}} end
 def deriv({:pow,x,a},x) do {:mul,a,{:pow,x,{:num, a-1}}} end
 def deriv({:Sqrt,x},x) do {:mul,{:div,1,2},{:div,1,{:sqrt,x}}} end
 def deriv({:trig,:sin,x},x) do {:mul,deriv(x,x){:trig,:cos,x}} end
 def deriv({:trig,:cos,x},x) do {:mul,deriv(x,x),{:mul,{:trig,:sin,x},{:num,-1}}} end

 def simplify({:num,a}) do a end
 def simplify({:var,x}) do x end
 def simplify({:add,e1,e2}) do simplify_add(simplify(e1),simplify(e2)) end
 def simplify({:mul,e1,e2}) do simplify_mul(simplify(e1),simplify(e2)) end
 def simplify({:div,e1,e2}) do simplify_div(simplify(e1),simplify(e2)) end

 def simplify_add(e1,{:num,0}) do e1 end
 def simplify_add({:num,0},e1) do e1 end
 def simplify_add({:num,a},{:num,b}) do simplify({:num,a+b})   end
 def simplify_add(e1,e2) do {:add,e1,e2} end

 def simplify_mul(e1,{:num,0}) do 0 end
 def simplify_mul({:num,0},e1) do 0 end
 def simplify_mul({:num,a},{:num,b}) do {:num,a*b} end
 def simplify_mul(e1,e2) do {:mul,e1,e2} end
 def simplify_mul(e1,{:num,1}) do e1 end
 def simplify_mul({:num,1},e1) do e1 end

 def pprint({:num, n}) do "#{n}" end
 def pprint({:var, v}) do "#{v}" end
 def pprint({:add, expr1, expr2}) do "#{pprint(expr1)} + #{pprint(expr2)}" end
 def pprint({:mul, expr1, expr2}) do "(#{pprint(expr1)} * #{pprint(expr2)})" end
 def pprint({:powr, expr1, expr2}) do "#{pprint(expr1)} ^(#{pprint(expr2)})" end
 def pprint({:div, expr1, expr2}) do "#{pprint(expr1)} /(#{pprint(expr2)})" end
end

defmodule Main do
  #IO.inspect(Deriv.deriv({:mul,{:trig,:sin,:x},{:num,-1}},:x))
  IO.inspect(Deriv.simplify({:div,{:num,9},{:num,3}}))
end
