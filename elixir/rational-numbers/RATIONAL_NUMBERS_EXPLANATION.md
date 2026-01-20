# RationalNumbers Function Explanations

This document provides detailed explanations for each function in the `RationalNumbers` module, covering Elixir syntax patterns, implementation rationale, and alternative approaches.

---

## add/2

### Implementation

```elixir
def add(a, b) do
  {a_num, a_den} = a
  {b_num, b_den} = b

  reduce({a_num * b_den + b_num * a_den, a_den * b_den})
end
```

### Elixir Syntax Patterns

Tuple Pattern Matching: `{a_num, a_den} = a` destructures the tuple `a` into its numerator and denominator components. This is one of Elixir's most powerful features, allowing us to extract values in a single, readable expression.

Tuple Construction: `{...}` syntax creates a new tuple to represent the result.

### Rationale

To add two fractions `a/b` and `c/d`, we need a common denominator. The formula is: `(a*d + c*b) / (b*d)`. This approach:

- Avoids floating-point arithmetic (stays exact)
- Works with any denominator pair
- Calls `reduce/1` to simplify the result

### Alternative Approaches

Pattern match in function head:

```elixir
def add({a_num, a_den}, {b_num, b_den}) do
  reduce({a_num * b_den + b_num * a_den, a_den * b_den})
end
```

This is more concise and idiomatic. Pattern matching directly in the function parameters eliminates the need for assignment inside the function body.

Use pipe operator for clarity:

```elixir
def add(a, b) do
  {a_num, a_den} = a
  {b_num, b_den} = b
  
  {a_num * b_den + b_num * a_den, a_den * b_den}
  |> reduce()
end
```

The pipe operator `|>` makes the data flow more explicit.

---

## subtract/2

### Implementation

```elixir
def subtract(a, b) do
  {a_num, a_den} = a
  {b_num, b_den} = b

  reduce({a_num * b_den - b_num * a_den, a_den * b_den})
end
```

### Elixir Syntax Patterns

Same tuple pattern matching as `add/2`. The only difference is the `-` operator instead of `+`.

### Rationale

Subtraction uses the same common denominator approach: `(a*d - c*b) / (b*d)`. This maintains integer arithmetic precision.

### Alternative Approaches

Reuse add with negation:

```elixir
def subtract(a, b) do
  {b_num, b_den} = b
  add(a, {-b_num, b_den})
end
```

This reduces code duplication by negating the second operand and reusing `add/2`. More DRY (Don't Repeat Yourself), but adds a function call.

Pattern match in parameters:

```elixir
def subtract({a_num, a_den}, {b_num, b_den}) do
  reduce({a_num * b_den - b_num * a_den, a_den * b_den})
end
```

---

## multiply/2

### Implementation

```elixir
def multiply(a, b) do
  {a_num, a_den} = a
  {b_num, b_den} = b

  reduce({a_num * b_num, a_den * b_den})
end
```

### Elixir Syntax Patterns

Tuple pattern matching for destructuring. Simple arithmetic operators `*`.

### Rationale

Multiplying rationals is straightforward: `(a/b) * (c/d) = (a*c)/(b*d)`. We multiply numerators together and denominators together, then reduce.

### Alternative Approaches

Pattern match in function head:

```elixir
def multiply({a_num, a_den}, {b_num, b_den}) do
  reduce({a_num * b_num, a_den * b_den})
end
```

Pre-reduce for efficiency (cross-cancellation):

```elixir
def multiply({a_num, a_den}, {b_num, b_den}) do
  # Cancel common factors before multiplication (more efficient for large numbers)
  gcd1 = Integer.gcd(a_num, b_den)
  gcd2 = Integer.gcd(b_num, a_den)
  
  reduce({
    div(a_num, gcd1) * div(b_num, gcd2),
    div(a_den, gcd2) * div(b_den, gcd1)
  })
end
```

This cross-cancellation approach reduces intermediate values, preventing integer overflow with large numbers, though it adds complexity.

---

## divide_by/2

### Implementation

```elixir
def divide_by(num, den) do
  {num_num, num_den} = num
  {den_num, den_den} = den

  reduce({num_num * den_den, num_den * den_num})
end
```

### Elixir Syntax Patterns

Tuple pattern matching with descriptive variable names. Parameter names `num` and `den` represent the dividend and divisor.

### Rationale

Division is multiplication by the reciprocal: `(a/b) ÷ (c/d) = (a/b) * (d/c) = (a*d)/(b*c)`. We flip the divisor and multiply.

### Alternative Approaches

Reuse multiply:

```elixir
def divide_by(num, {den_num, den_den}) do
  multiply(num, {den_den, den_num})
end
```

This is more DRY by reusing `multiply/2` with the reciprocal.

Pattern match both parameters:

```elixir
def divide_by({num_num, num_den}, {den_num, den_den}) do
  reduce({num_num * den_den, num_den * den_num})
end
```

Add guard for division by zero:

```elixir
def divide_by({num_num, num_den}, {0, _den_den}) do
  raise ArithmeticError, "cannot divide by zero"
end

def divide_by({num_num, num_den}, {den_num, den_den}) do
  reduce({num_num * den_den, num_den * den_num})
end
```

Pattern matching with multiple function clauses and guards handles edge cases explicitly.

---

## abs/1

### Implementation

```elixir
def abs(a) do
  {num, den} = a

  reduce({Kernel.abs(num), Kernel.abs(den)})
end
```

### Elixir Syntax Patterns

Module-qualified function call: `Kernel.abs/1` is explicitly qualified to avoid confusion with our own `abs/1` function. Elixir automatically imports many `Kernel` functions, but we use the full name for clarity since we can't recursively call a function with the same name as an imported one.

### Rationale

The absolute value of a rational is the absolute value of both components. We call `reduce/1` to normalize the sign (ensuring positive denominator).

### Alternative Approaches

Pattern match and use pipe:

```elixir
def abs({num, den}) do
  {Kernel.abs(num), Kernel.abs(den)} |> reduce()
end
```

Multiple clauses for positive/negative:

```elixir
def abs({num, den}) when num >= 0 and den >= 0, do: {num, den}
def abs({num, den}) when num < 0, do: reduce({-num, Kernel.abs(den)})
def abs({num, den}) when den < 0, do: reduce({Kernel.abs(num), -den})
```

Uses guard clauses (`when`) to handle different sign combinations. More explicit but verbose.

---

## pow_rational/2

### Implementation

```elixir
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
```

### Elixir Syntax Patterns

`cond` expression: Evaluates multiple conditions in order, executing the first true clause. Similar to `if/else if/else` in other languages.

`true` as catch-all: The final `true ->` clause acts as the default case.

`Integer.pow/2`: Built-in function for integer exponentiation.

### Rationale

Raising a rational to a power: `(a/b)^n = a^n / b^n`. For negative exponents, we invert first: `(a/b)^(-n) = (b/a)^n`.

The `cond` structure handles three cases:

1. Zero exponent → return 1
2. Positive exponent → raise normally
3. Negative exponent → invert and raise to positive power

### Alternative Approaches

Pattern match with multiple function clauses:

```elixir
def pow_rational(_a, 0), do: {1, 1}

def pow_rational({num, den}, n) when n > 0 do
  reduce({Integer.pow(num, n), Integer.pow(den, n)})
end

def pow_rational({num, den}, n) when n < 0 do
  pos_n = -n
  reduce({Integer.pow(den, pos_n), Integer.pow(num, pos_n)})
end
```

Uses multiple function clauses with guard clauses (`when`). This is more idiomatic Elixir - pattern matching is preferred over conditionals when possible.

Use case instead of cond:

```elixir
def pow_rational({num, den}, n) do
  case n do
    0 -> {1, 1}
    n when n > 0 -> reduce({Integer.pow(num, n), Integer.pow(den, n)})
    n when n < 0 -> 
      pos_n = -n
      reduce({Integer.pow(den, pos_n), Integer.pow(num, pos_n)})
  end
end
```

`case` with guards is another option, but multiple function clauses is more idiomatic.

---

## pow_real/2

### Implementation

```elixir
def pow_real(x, n) do
  {num, den} = n
  :math.pow(x, num / den)
end
```

### Elixir Syntax Patterns

Erlang module call: `:math.pow/2` calls the Erlang standard library's `math` module. The `:` prefix denotes an atom, used for Erlang modules.

Division operator `/`: Always returns a float in Elixir (unlike `div/2` which returns integer).

### Rationale

Computing `x^(a/b)` requires `x^(a/b) = ∜(x^a)` which is irrational in general. We convert to floating-point and use Erlang's math library.

### Alternative Approaches

Pattern match in function head:

```elixir
def pow_real(x, {num, den}) do
  :math.pow(x, num / den)
end
```

Slightly more concise.

Use root and power separately:

```elixir
def pow_real(x, {num, den}) do
  x
  |> :math.pow(num)
  |> :math.pow(1 / den)
end
```

Computes `(x^num)^(1/den)` but is mathematically equivalent and potentially more numerically stable.

Use explicit float conversion:

```elixir
def pow_real(x, {num, den}) do
  exponent = num / den
  :math.pow(1.0 * x, exponent)
end
```

Ensures `x` is treated as float, though `:math.pow` handles this automatically.

---

## reduce/1

### Implementation

```elixir
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
```

### Elixir Syntax Patterns

`cond` for multiple conditions.

`Integer.gcd/2`: Built-in greatest common divisor function.

`div/2`: Integer division (truncates, doesn't round).

Recursion: The `den < 0` case recursively calls `reduce/1` with flipped signs.

### Rationale

Reduction ensures a canonical form:

1. Zero numerator → `{0, 1}` (canonical zero)
2. Negative denominator → flip both signs (keep denominator positive)
3. Otherwise → divide by GCD to get lowest terms

The `cond` structure checks these conditions in priority order.

### Alternative Approaches

Multiple function clauses with pattern matching:

```elixir
def reduce({0, _den}), do: {0, 1}

def reduce({num, den}) when den < 0 do
  reduce({-num, -den})
end

def reduce({num, den}) do
  g = Integer.gcd(num, den)
  {div(num, g), div(den, g)}
end
```

More idiomatic Elixir. Each clause is a separate pattern, making the logic very clear.

Use case with guard:

```elixir
def reduce({num, den}) do
  case {num, den} do
    {0, _} -> {0, 1}
    {n, d} when d < 0 -> reduce({-n, -d})
    {n, d} ->
      g = Integer.gcd(n, d)
      {div(n, g), div(d, g)}
  end
end
```

Iterative sign normalization without recursion:

```elixir
def reduce({num, den}) do
  # Normalize sign first
  {num, den} = if den < 0, do: {-num, -den}, else: {num, den}
  
  # Handle zero
  if num == 0 do
    {0, 1}
  else
    g = Integer.gcd(num, den)
    {div(num, g), div(den, g)}
  end
end
```

Avoids recursion, but uses nested `if` statements which are less idiomatic than pattern matching.

---

## Summary of Elixir Patterns Used

1. **Pattern Matching**: Destructuring tuples to extract values
2. **Multiple Function Clauses**: Defining the same function multiple times with different patterns (alternative approach)
3. **Guard Clauses**: `when` conditions in function heads for additional constraints
4. **`cond` Expression**: Multi-way conditional (like switch/case in other languages)
5. **Recursion**: Functions calling themselves (in `reduce/1`)
6. **Pipe Operator `|>`**: Chaining function calls for better readability
7. **Erlang Interop**: Calling Erlang libraries with `:module.function` syntax
8. **Tuple Construction**: Using `{...}` to create immutable tuple data structures

The chosen implementations balance readability with Elixir conventions, favoring explicit tuple destructuring in the function body over parameter pattern matching for clarity.
