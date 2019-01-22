defmodule Practice.Factor do
	def factor(x) do
		factor(x, [])
	end

	# while x is even, divide by two
	defp factor(x, acc) do
		cond do
			x == 0 -> []
			x == 1 -> Enum.sort(acc)
			# if x is divisible by 2
			rem(x, 2) == 0 ->
				factor(div(x, 2), [2 | acc])
			# don't support prime factorization of negative numbers
			x > 0 ->
				factor(x, 3, acc)
		end
	end

	# x is odd
	defp factor(x, i, acc) do
		cond do
			i * i <= x and rem(x, i) == 0 ->
				factor(div(x, i), i, [i | acc])
			i * i <= x -> 
				factor(x, i + 2, acc)
			# x is a prime number > 2
			x > 2 -> 
				Enum.sort([x | acc])
			# base case, return accumulator
			true -> Enum.sort(acc)
		end
	end
end