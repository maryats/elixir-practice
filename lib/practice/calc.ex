defmodule Practice.Calc do
  def parse_float(text) do
    {num, _} = Float.parse(text)
    num
  end

  def calc(expr) do
    # This should handle +,-,*,/ with order of operations,
    # but doesn't need to handle parens.
    expr
    |> String.split(~r/\s+/)
    |> Enum.map(&tag_token/1)
    |> postfix
    |> evaluate # as a stack calculator using pattern matching
  end

  def tag_token(x) do
    case x do
      x when x in ["+", "-", "*", "/"] -> {:op, x}
      x -> {:num, parse_float(x)}
    end
  end

  def postfix(expr) do
    postfix(expr, [], [])
  end

  defp postfix(expr, ops, output) do
    x = List.first(expr)
    case x do
      nil -> Enum.reverse(pop_ops(ops, output))
      {:num, _} -> postfix(tl(expr), ops, [x | output])
      {:op, _} -> handle_op(expr, ops, output)
    end
  end

  # ASSUMES: expr is non-empty
  defp handle_op(expr, ops, output) do
    x = hd(expr) 
    y = List.first(ops)

    if y == nil or precedence(x) > precedence(y) do
      postfix(tl(expr), [x | ops], output)
    else 
      handle_op(expr, tl(ops), [y | output])
    end
  end

  defp pop_ops(ops, output) do
    x = List.first(ops)
    case x do
      nil -> output
      x -> pop_ops(tl(ops), [x | output])
    end
  end

  defp precedence(op) do
    {:op, x} = op
    case x do
      "+" -> 1
      "-" -> 1
      "*" -> 2
      "/" -> 2
    end
  end

  def evaluate(expr) do
    evaluate(expr, [])
  end

  defp evaluate(expr, stack) do
    x = List.first(expr)

    case x do
      nil -> hd(stack)
      {:num, operand} -> evaluate(tl(expr), [operand | stack])
      {:op, operator} -> evaluate(tl(expr), perform_op(operator, stack))
    end
  end

  # ASSUMES: stack has at least two elements
  defp perform_op(op, stack) do
      b = hd(stack)
      a = Enum.at(stack, 1)
      new_stack = Enum.slice(stack, 2, 1)
      case op do
          "+" -> [a + b | new_stack]
          "-" -> [a - b | new_stack]
          "*" -> [a * b | new_stack]
          "/" -> [a / b | new_stack]
      end
  end

end
