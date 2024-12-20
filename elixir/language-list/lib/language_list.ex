defmodule LanguageList do
  def new(), do: []
  def add(list, language), do: [language | list]
  def remove([_ | tail]), do: tail
  def remove([]), do: []
  def first([head | _]), do: head
  def first([]), do: nil
  def count(list) do
    list
    |> Enum.uniq()
    |> length()
  end
  def functional_list?(list), do: "Elixir" in list
end
