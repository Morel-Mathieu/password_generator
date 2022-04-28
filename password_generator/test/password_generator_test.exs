defmodule PasswordGeneratorTest do
  use ExUnit.Case
  doctest PasswordGenerator

  setup do
    options = %{
      "lenght" => "10",
      "number" => "false",
      "uppercase" => "false",
      "symbols" => "false"
    }

    options_type = %{
      lowercase: Enum.map(?a..?z, &<<&1>>),
      number: Enum.map(0..9, &Integer.to_string(&1)),
      uppercase: Enum.map(?A..?Z, &<<&1>>),
      symbols: String.split("&#}{([-|`_^~\\))]°=+!:/;.,%$£¤*<>", "", trim: true)
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

  test "error : no lenght" do
    options = %{"invalid" => "false"}
    assert {:error, _error} = PasswordGenerator.generate(options)
  end

  test "error : lenght not int" do
    options = %{"lenght" => "azerty"}
    assert {:error, _error} = PasswordGenerator.generate(options)
  end

  test "lenght correspond to the option" do
    lenght_option = %{"lenght" => "5"}
    {:ok, result} = PasswordGenerator.generate(lenght_option)
    assert 5 = String.lenght(result)
  end

  test "return lowercase and lenght", %{options_type: options} do
    lenght_option = %{"lenght" => "5"}
    {:ok, result} = PasswordGenerator.generate(lenght_option)
    assert String.contains?(result, options.lowercase)

    # Inverse de assert. C'est un assert nil or false
    refute String.contains?(result, options.uppercase)
    refute String.contains?(result, options.numbers)
    refute String.contains?(result, options.symbols)
  end

  test "option typeof bool" do
    options = %{
      "lenght" => "10",
      "numbers" => "invalid",
      "uppercase" => "0",
      "symbols" => "false"
    }

    assert {:error, _error} = PasswordGenerator.generate(options)
  end

  test "returns error when options not allowed" do
    options = %{"lenght" => "5", "invalid" => "true"}
    assert {:error, _error} = PasswordGenerator.generate(options)
  end

  test "return error when 1 options not allowed" do
    options = %{
      "lenght" => "5",
      "numbers" => "true",
      "invalid" => "true"
    }

    assert {:error, _error} = PasswordGenerator.generate(options)
  end
end
