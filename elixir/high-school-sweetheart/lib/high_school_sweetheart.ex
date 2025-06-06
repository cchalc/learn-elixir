defmodule HighSchoolSweetheart do
  def first_letter(name) do
    name |> String.trim() |> String.first()
  end

  def initial(name) do
    name |> String.upcase() |> first_letter() |> Kernel.<>(".")
  end

  def initials(full_name) do
    parts = String.split(full_name)

    case parts do
      [first, last] ->
        initial(first) <> " " <> initial(last)
        _ ->
        raise ArgumentError, "Expected exactly two names, got: #{length(parts)}"
    end
  end

  def pair(full_name1, full_name2) do
    i1 = initials(full_name1)
    i2 = initials(full_name2)
    """
         ******       ******
       **      **   **      **
     **         ** **         **
    **            *            **
    **                         **
    **     #{i1}  +  #{i2}     **
     **                       **
       **                   **
         **               **
           **           **
             **       **
               **   **
                 ***
                  *
    """
  end
end
