# mytests.exs
defmodule AnotherTest do
  use ExUnit.Case
  doctest Secrets

  test "secret_add with positive numbers" do
    adder = Secrets.secret_add(2)
    assert adder.(2) == 4
    assert adder.(10) == 12
  end

  test "secret_add with negative numbers" do
    adder = Secrets.secret_add(-3)
    assert adder.(2) == -1
    assert adder.(-5) == -8
  end

  test "secret_subtract basics" do
    subtractor = Secrets.secret_subtract(2)
    assert subtractor.(10) == 8
    assert subtractor.(3) == 1
  end

  test "secret_multiply operations" do
    multiplier = Secrets.secret_multiply(7)
    assert multiplier.(3) == 21
    assert multiplier.(-4) == -28
  end

  test "secret_divide operations" do
    divider = Secrets.secret_divide(2)
    assert divider.(10) == 5
    assert divider.(20) == 10
  end

  test "secret_and bitwise operations" do
    ander = Secrets.secret_and(14)
    assert ander.(13) == 12
    assert ander.(7) == 6
  end

  test "secret_xor bitwise operations" do
    xorer = Secrets.secret_xor(5)
    assert xorer.(3) == 6
    assert xorer.(6) == 3
  end

  test "secret_combine chaining operations" do
    adder = Secrets.secret_add(1)
    multiplier = Secrets.secret_multiply(2)
    combined = Secrets.secret_combine(adder, multiplier)
    assert combined.(3) == 8  # (3 + 1) * 2
  end
end
