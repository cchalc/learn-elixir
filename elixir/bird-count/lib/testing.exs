defmodule BirdCount do
  def today([]), do: nil
  def today([head | _]), do: head

end

IO.puts(BirdCount.today([34, 335, 232]))
