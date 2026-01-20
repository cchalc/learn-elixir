defmodule RationalNumbers do
  @type rational :: {integer, integer}

  @doc """
  Add two rational numbers
  """
  @spec add(a :: rational, b :: rational) :: rational
  def add(a, b) do
    {a_num, a_den} = a
    {b_num, b_den} = b

    reduce({a_num * b_den + b_num * a_den, a_den * b_den})
  end

  @doc """
  Subtract two rational numbers
  """
  @spec subtract(a :: rational, b :: rational) :: rational
  def subtract(a, b) do
    {a_num, a_den} = a
    {b_num, b_den} = b

    reduce({a_num * b_den - b_num * a_den, a_den * b_den})
  end

  @doc """
  Multiply two rational numbers
  """
  @spec multiply(a :: rational, b :: rational) :: rational
  def multiply(a, b) do
    {a_num, a_den} = a
    {b_num, b_den} = b

    reduce({a_num * b_num, a_den * b_den})
  end

  @doc """
  Divide two rational numbers
  """
  @spec divide_by(num :: rational, den :: rational) :: rational
  def divide_by(num, den) do
    {num_num, num_den} = num
    {den_num, den_den} = den

    reduce({num_num * den_den, num_den * den_num})
  end

  @doc """
  Absolute value of a rational number
  """
  @spec abs(a :: rational) :: rational
  def abs(a) do
    {num, den} = a

    reduce({Kernel.abs(num), Kernel.abs(den)})
  end

  @doc """
  Exponentiation of a rational number by an integer
  """
  @spec pow_rational(a :: rational, n :: integer) :: rational
  def pow_rational(a, n) do
    {num, den} = a

    cond do
      n == 0 ->
        {1, 1}

      n > 0 ->
        reduce({Integer.pow(num, n), Integer.pow(den, n)})

      true ->
        pos_n = -n
        reduce({Integer.pow(den, pos_n), Integer.pow(num, pos_n)})
    end
  end

  @doc """
  Exponentiation of a real number by a rational number
  """
  @spec pow_real(x :: integer, n :: rational) :: float
  def pow_real(x, n) do
    {num, den} = n
    :math.pow(x, num / den)
  end

  @doc """
  Reduce a rational number to its lowest terms
  """
  @spec reduce(a :: rational) :: rational
  def reduce(a) do
    {num, den} = a

    cond do
      num == 0 ->
        {0, 1}

      den < 0 ->
        reduce({-num, -den})

      true ->
        g = Integer.gcd(num, den)
        {div(num, g), div(den, g)}
    end
  end
end
