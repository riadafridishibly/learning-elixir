defmodule Bar do
  def bar(atom) do
    IO.puts("bar called with #{atom}")
    Atom.to_string(atom)
  end
end

defmodule Foo do
  import Bar

  # NOTE: function call, see plug docs
  # https://hexdocs.pm/plug/readme.html#plug-router
  bar :hello

  def fun() do
    "Foo.fun called"
  end
end

IO.puts(Foo.fun())
