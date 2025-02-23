defmodule KitchenCalculator do
  @moduledoc """
  Functions for converting between different kitchen units of measurement.
  """

  @conversion_factors %{
    :cup => 240,
    :fluid_ounce => 30,
    :teaspoon => 5,
    :tablespoon => 15,
    :milliliter => 1
  }

  @doc """
  Extracts the numeric volume from a volume-pair tuple.

  ## Examples

      iex> KitchenCalculator.get_volume({:cup, 2.5})
      2.5

      iex> KitchenCalculator.get_volume({:teaspoon, 3})
      3
  """
  def get_volume({_unit, volume}), do: volume

  def to_milliliter(volume_pair) do
    # Please implement the to_milliliter/1 functions
  end

  def from_milliliter(volume_pair, unit) do
    # Please implement the from_milliliter/2 functions
  end

  def convert(volume_pair, unit) do
    # Please implement the convert/2 function
  end
end
