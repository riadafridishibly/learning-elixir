# https://stackoverflow.com/a/29674651
defmodule Benchmark do
  defp pretty(tuple) do
    {elem(tuple, 0) / 1_000_000, elem(tuple, 1)}
  end

  def measure(function, n) do
    function
    |> :timer.tc([n])
    |> pretty()
  end
end

# Tail Call Optimized
defmodule SumTCO do
  defp sum(0, running_sum), do: running_sum
  defp sum(n, running_sum), do: sum(n - 1, n + running_sum)

  def sum(n) when n < 0, do: raise("number can't be negative")
  def sum(n), do: sum(n, 0)
end

defmodule Sum do
  def sum(0), do: 0
  def sum(n) when n < 0, do: raise("number can't be negative")
  def sum(n), do: n + sum(n - 1)
end

n = 100_000_000

{non_tco_time, non_tco_result} = Benchmark.measure(&Sum.sum/1, n)
{tco_time, tco_result} = Benchmark.measure(&SumTCO.sum/1, n)

IO.puts("   Sum.sum(1..#{n}) = #{non_tco_result} took = #{non_tco_time}sec")
IO.puts("SumTCO.sum(1..#{n}) = #{tco_result} took = #{tco_time}sec")
