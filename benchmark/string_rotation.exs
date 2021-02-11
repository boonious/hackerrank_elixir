# mix run benchmark/string_rotation.exs

alphabet_list = "abcdefghijklmnopqrstuvwxyz" |> String.split("", trim: true)
max_string_length = 50
number_of_string = 1000

strings =
  for _i <- 1..number_of_string do
    Enum.reduce(1..Enum.random(1..max_string_length), [], fn _i, acc ->
      [Enum.random(alphabet_list) | acc]
    end)
    |> IO.iodata_to_binary()
  end

Benchee.run(
  %{
    "String rotation - list-based" => fn -> for string <- strings, do: FP.AdHoc.rotate(string) end,
    "String rotation - binary matching" => fn -> for string <- strings, do: FP.AdHoc.rotate_binary(string) end
  },
  time: 10,
  memory_time: 2
)
