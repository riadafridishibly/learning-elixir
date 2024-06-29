defmodule Debug do
  def p(v, msg \\ "") do
    IO.puts([msg, inspect(v)])
  end
end

t1 = {"a", "b", "z"}
Debug.p(t1, "t1: ")
t2 = put_elem(t1, 2, "c")
Debug.p(t2, "t2: ")
t3 = Tuple.append(t2, "d")
Debug.p(t3, "t3: ")

filterEmpty = fn enumerable -> Enum.filter(enumerable, fn x -> x != "" end) end

charsList = "ABCDEFGHIJKLMNOPQRSTUVWXYZ" |> String.split("") |> filterEmpty.()

res =
  1..10
  |> Enum.map(fn _ -> Enum.random(charsList) end)
  |> Enum.join("")

Debug.p(res, "Random Enum Generate List: ")

charsTuple = "ABCDEFGHIJKLMNOPQRSTUVWXYZ" |> String.split("") |> List.to_tuple()

res =
  1..10
  |> Enum.map(fn _ -> elem(charsTuple, :rand.uniform(tuple_size(charsTuple) - 1)) end)
  |> Enum.join("")

Debug.p(res, "Random Enum Generate Tuple: ")

{reversed, count} =
  Enum.reduce(charsList, {[], 0}, fn item, {acc, count} -> {[item | acc], count + 1} end)

Debug.p(reversed |> Enum.join(""), "Reversed: ")
Debug.p(count, "Count: ")

defmodule MyApp.User do
  require Record
  Record.defrecord(:user, id: nil, active: true, name: nil)
end

defmodule Main do
  def main do
    alias MyApp.User
    require User
    goku = User.user(id: 0, name: "Goku", active: true)
    Debug.p(goku, "User.goku: ")

    field = "New Name"
    goku = User.user(goku, name: field)
    Debug.p(User.user(goku, :name), "Name: ")
    Debug.p(User.user(goku, :id), "Name: ")
  end
end

Main.main()
