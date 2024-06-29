# Processes

pid =
  spawn(fn ->
    receive do
      msg -> IO.puts("received: #{msg}")
    end
  end)

send(pid, "hello")

defmodule MyApp.Receiver do
  def run(counter) do
    IO.puts(counter)

    receive do
      :incr -> run(counter + 1)
      {:incr, by} -> run(counter + by)
      :stop -> :ok
    after
      # executed after 250 milliseconds

      250 ->
        (fn ->
           IO.puts("after 250ms")
           run(counter)
         end).()
    end
  end
end

pid =
  spawn(fn ->
    MyApp.Receiver.run(0)
  end)

:timer.sleep(1000)

send(pid, :incr)
:timer.sleep(2000)

send(pid, {:incr, 10})
:timer.sleep(1000)

send(pid, :stop)
