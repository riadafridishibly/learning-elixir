# pid1 =
#   spawn(fn ->
#     :timer.sleep(500)
#     IO.puts("going to sleep")
#   end)
#
# pid2 =
#   spawn(fn ->
#     :timer.sleep(1_000)
#     raise "Can't be over 9000!"
#   end)
#
# Process.monitor(pid1)
# Process.monitor(pid2)
#
# receive do
#   msg -> IO.puts(inspect(msg))
# end
#
# receive do
#   msg -> IO.puts(inspect(msg))
# end
#
# :timer.sleep(3_000)

defmodule MyApp do
  def run(main_pid, functions) do
    state =
      Enum.into(functions, %{}, fn function ->
        pid = spawn(fn -> function.() end)
        ref = Process.monitor(pid)
        {ref, function}
      end)

    send(main_pid, :ready)
    supervise(state)
  end

  defp supervise(state) do
    state =
      receive do
        {:DOWN, _ref, :process, _pid, :normal} ->
          state

        {:DOWN, ref, :process, _pid, _not_normal} ->
          {function, state} = Map.pop(state, ref)
          pid = spawn(function)
          ref = Process.monitor(pid)
          Map.put(state, ref, function)
      end

    supervise(state)
  end
end

defmodule MyApp.Counter do
  def run() do
    # IO.puts("Registered...")
    # IO.puts("info #{Process.whereis(:counter)}")
    Process.register(self(), :mycounter)
    # IO.puts("info #{Process.whereis(:counter)}")
    run(0)
  end

  defp run(sum) do
    IO.puts("runnint total: #{sum}")

    receive do
      {:increment, n} -> run(sum + n)
      :exit -> :ok
    end
  end

  def increment(n \\ 1) do
    pid = Process.whereis(:mycounter)
    send(pid, {:increment, n})
  end
end

main_pid = self()

spawn(fn ->
  MyApp.run(main_pid, [&MyApp.Counter.run/0])
end)

receive do
  :ready -> :ok
after
  1000 -> raise "supervisor hasn't started yet"
end

IO.puts("#{inspect(Process.whereis(:mycounter))}")
MyApp.Counter.increment(1)
MyApp.Counter.increment(3)
MyApp.Counter.increment("a")

:timer.sleep(500)
MyApp.Counter.increment(10)
