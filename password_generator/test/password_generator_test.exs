defmodule PasswordGeneratorTest do
  use ExUnit.Case
  doctest PasswordGenerator

  setup do
    # Les options de notre générateur de mot de passe
    options = %{
      "length" => "10",
      "numbers" => "false",
      "uppercase" => "false",
      "symbols" => "false"
    }

    options_type = %{
      lowercase: Enum.map(?a..?z, &<<&1>>),
      numbers: Enum.map(0..9, &Integer.to_string(&1)),
      uppercase: Enum.map(?A..?Z, &<<&1>>),
      symbols: String.split("&#}{([-|`_^~))]°=+!:/;.,%$£¤*<>", "", trim: true)
    }

    {:ok, result} = PasswordGenerator.generate(options)

    %{
      options_type: options_type,
      result: result
    }
  end

  test "return a string", %{result: result} do
    assert is_bitstring(result)
  end

  test "error : no length" do
    options = %{"invalid" => "false"}
    assert {:error, _error} = PasswordGenerator.generate(options)
  end

  test "error : length not int" do
    options = %{"length" => "azerty"}
    assert {:error, _error} = PasswordGenerator.generate(options)
  end

  test "length work" do
    length_option = %{"length" => "5"}
    {:ok, result} = PasswordGenerator.generate(length_option)
    assert 5 = String.length(result)
  end

  test "return lowercase and length", %{options_type: options} do
    length_option = %{"length" => "5"}
    {:ok, result} = PasswordGenerator.generate(length_option)
    assert String.contains?(result, options.lowercase)

    # Inverse de assert. C'est un assert nil or false
    refute String.contains?(result, options.uppercase)
    refute String.contains?(result, options.numbers)
    refute String.contains?(result, options.symbols)
  end

  test "options typeof bool" do
    options = %{
      "length" => "10",
      "numbers" => "invalid",
      "uppercase" => "0",
      "symbols" => "false"
    }

    assert {:error, _error} = PasswordGenerator.generate(options)
  end

  test "returns error when options not allowed" do
    options = %{"length" => "5", "invalid" => "true"}
    assert {:error, _error} = PasswordGenerator.generate(options)
  end

  test "return error when 1 options not allowed" do
    options = %{
      "length" => "5",
      "numbers" => "true",
      "invalid" => "true"
    }

    assert {:error, _error} = PasswordGenerator.generate(options)
  end

  test "returns string uppercase", %{options_type: options} do
    options_with_uppercase = %{
      "length" => "10",
      "numbers" => "false",
      "uppercase" => "true",
      "symbols" => "false"
    }

    {:ok, result} = PasswordGenerator.generate(options_with_uppercase)

    assert String.contains?(result, options.uppercase)

    # Inverse de assert. C'est un assert nil or false
    refute String.contains?(result, options.numbers)
    refute String.contains?(result, options.symbols)
  end

  test "returns string with numbers", %{options_type: options} do
    options_with_numbers = %{
      "length" => "10",
      "numbers" => "true",
      "uppercase" => "false",
      "symbols" => "false"
    }

    {:ok, result} = PasswordGenerator.generate(options_with_numbers)

    assert String.contains?(result, options.numbers)

    # Inverse de assert. C'est un assert nil or false
    refute String.contains?(result, options.uppercase)
    refute String.contains?(result, options.symbols)
  end

  test "returns string with numbers & uppercase", %{options_type: options} do
    options_included = %{
      "length" => "10",
      "numbers" => "true",
      "uppercase" => "true",
      "symbols" => "false"
    }

    {:ok, result} = PasswordGenerator.generate(options_included)

    assert String.contains?(result, options.numbers)
    assert String.contains?(result, options.uppercase)

    # Inverse de assert. C'est un assert nil or false
    refute String.contains?(result, options.symbols)
  end

  test "returns string with symbols", %{options_type: options} do
    options_included = %{
      "length" => "10",
      "numbers" => "false",
      "uppercase" => "false",
      "symbols" => "true"
    }

    {:ok, result} = PasswordGenerator.generate(options_included)

    assert String.contains?(result, options.symbols)

    # Inverse de assert. C'est un assert nil or false
    refute String.contains?(result, options.numbers)
    refute String.contains?(result, options.uppercase)
  end

  test "returns string with all options", %{options_type: options} do
    options_included = %{
      "length" => "10",
      "numbers" => "true",
      "uppercase" => "true",
      "symbols" => "true"
    }

    {:ok, result} = PasswordGenerator.generate(options_included)

    assert String.contains?(result, options.symbols)
    assert String.contains?(result, options.numbers)
    assert String.contains?(result, options.uppercase)
  end

  test "returns string with symbols and uppercase", %{options_type: options} do
    options_included = %{
      "length" => "10",
      "numbers" => "false",
      "uppercase" => "true",
      "symbols" => "true"
    }

    {:ok, result} = PasswordGenerator.generate(options_included)

    assert String.contains?(result, options.symbols)
    assert String.contains?(result, options.uppercase)
    refute String.contains?(result, options.numbers)
  end

  test "returns string with symbols and numbers", %{options_type: options} do
    options_included = %{
      "length" => "10",
      "numbers" => "true",
      "uppercase" => "false",
      "symbols" => "true"
    }

    {:ok, result} = PasswordGenerator.generate(options_included)

    assert String.contains?(result, options.numbers)
    assert String.contains?(result, options.symbols)
    refute String.contains?(result, options.uppercase)
  end
end
