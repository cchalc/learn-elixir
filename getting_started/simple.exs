IO.puts("hello world")

name = "Peter" # String
age = 32 # Integer
age_hex = 0x20 # Integer in Hex notation
height = 190.47 # Float
height_sci = 1.9047e2 # Float in scientific notation
adult? = true # Boolean
status = :active # Atom
address = nil # The 'None/null/Nil' value

IO.inspect([name, age, age_hex, height, height_sci, adult?, status, address])


age = 31 # Integer

IO.inspect([age])

