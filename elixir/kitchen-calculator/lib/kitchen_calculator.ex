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

  @doc """
  Converts a volume-pair tuple to milliliters.

  ## Examples

      iex> KitchenCalculator.to_milliliter({:cup, 2.5})
      {:milliliter, 600.0}

      iex> KitchenCalculator.to_milliliter({:teaspoon, 3})
      {:milliliter, 15.0}
  """
  def to_milliliter({unit, volume}) do
    {:milliliter, volume * @conversion_factors[unit]}
  end

  @doc """
  Converts a volume from milliliters to the desired unit.

  ## Examples

      iex> KitchenCalculator.from_milliliter({:milliliter, 240}, :cup)
      {:cup, 1.0}

      iex> KitchenCalculator.from_milliliter({:milliliter, 30}, :fluid_ounce)
      {:fluid_ounce, 1.0}
  """
  def from_milliliter({:milliliter, volume}, desired_unit) do
    {desired_unit, volume / @conversion_factors[desired_unit]}
  end

  @doc """
  Converts a volume-pair tuple to another unit.

  ## Examples

      iex> KitchenCalculator.convert({:cup, 2}, :fluid_ounce)
      {:fluid_ounce, 16.0}

      iex> KitchenCalculator.convert({:teaspoon, 3}, :tablespoon)
      {:tablespoon, 1.0}
  """
  def convert(volume_pair, unit) do
    volume_pair
    |> to_milliliter()
    |> from_milliliter(unit)
  end
end
