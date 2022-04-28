defmodule PasswordGenerator do
  @moduledoc """
  Documentation for `PasswordGenerator`.
  """
  @allowed_options [:lenght, :numbers, :symbols, :uppercase]

  def generate(options) do
    lenght = Map.has_key?(options, "lenght")
    validate_lenght(lenght, options)
  end

  defp validate_lenght(false, _options), do: {:error, "Please provide a lenght"}

  defp validate_lenght(true, options) do
    numbers = Enum.map(0..9, &Integer.to_string(&1))
    lenght = options["lenght"]
    lenght = String.contains?(lenght, numbers)
    validate_lenght_is_integer(lenght, options)
  end

  defp validate_lenght_is_integer(false, _option), do: {:error, "Lenght might be an integer"}

  defp validate_lenght_is_integer(true, options) do
    lenght =
      options["lenght"]
      |> String.trim()
      |> String.to_integer()

    options_without_lenght = Map.delete(options, "lenght")

    options_value = Map.values(options_without_lenght)

    value =
      options_value
      |> Enum.all?(fn arguments -> String.to_atom(arguments) |> is_boolean() end)

    validate_options_values_are_bool(value, lenght, options_without_lenght)
  end

  defp validate_options_values_are_bool(false, _lenght, _option),
    do: {:error, "Lenght might be an integer"}

  defp validate_options_values_are_bool(true, lenght, options) do
    options = included_options(options)
    invalid_options? = options |> Enum.any?(&(&1 not in @allowed_options))
    validate_options(invalid_options?, lenght, options)
  end

  defp included_options(options) do
    Enum.filter(options, fn {_key, value} ->
      value |> String.trim() |> String.to_existing_atom()
    end)
    |> Enum.map(fn {key, _value} -> String.to_atom(key) end)
  end

  defp validate_options(true, _lenght, _options), do: {:error, "Only numbers, uppercase, symbols"}

  defp validate_options(false, lenght, options) do
    generate_string(lenght, options)
  end

  defp include(options) do
    options
    |> Enum.map(&get(&1))
  end

  defp get(:lower) do
    <<Enum.random(?a..?z)>>
  end

  defp generate_string(size, options) do
    options = [:lowercase_letter | options]
    included = include(options)

    size = size - Enum.count(included)
    random_strings = generate_random_string(size, options)

    strings = included ++ random_strings
    get_result(strings)
  end

  defp get_result(strings) do
    string = strings |> Enum.shuffle() |> to_string()
    {:ok, string}
  end

  defp generate_random_string(lenght, options) do
    Enum.map(1..lenght, fn -> Enum.random(options) |> get() end)
  end
end
