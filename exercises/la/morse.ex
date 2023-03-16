defmodule Morse do
  def test() do
    morse = morse()
    hash = hash_map(morse)
    # Map.new(hash, fn {char, list} -> {List.to_string([char]), list} end)
    msg = encode(text(), hash)
    IO.inspect(msg)
    decode(msg, morse)
  end

  def decode_test() do
    morse_tree = morse()
    msg = second()
    decode(msg, morse_tree)
  end

  def mor() do '.-.. .- -.. ..- -. -.-' end

  def first() do '.- .-.. .-.. ..-- -.-- --- ..- .-. ..-- -... .- ... . ..-- .- .-. . ..-- -... . .-.. --- -. --. ..-- - --- ..-- ..- ... ' end

  def second() do '.... - - .--. ... ---... .----- .----- .-- .-- .-- .-.-.- -.-- --- ..- - ..- -... . .-.-.- -.-. --- -- .----- .-- .- - -.-. .... ..--.. ...- .----. -.. .--.-- ..... .---- .-- ....- .-- ----. .--.-- ..... --... --. .--.-- ..... ---.. -.-. .--.-- ..... .---- ' end

  def text() do 'axel h' end

  # This encoding is tail recursive due to it needing to
  # resolve the "to_morse" function before going into the
  # next recursion, and the last thing it will do is to
  # return the finished list.
  # For each character in the text of length (n), their
  # sequence has to be translated into the morse code.
  # If (m) is the length of all the morse codes, the
  # complexity will belong to O(n*m)
  def encode(text, hash) do
    encode(text, hash, [])
  end
  def encode([], _, list) do list end
  def encode([char|text], hash, list) do
    encode(text, hash, list ++ to_morse(hash[char]))
  end

  # This can be more efficient.
  def to_morse([]) do [32] end # " "
  def to_morse([head|tail]) do
    case head do
      1 -> [45] ++ to_morse(tail) # "-"
      0 -> [46] ++ to_morse(tail) # "."
    end
  end

  def decode([], _) do [] end
  def decode(morsemsg, tree) do
    {char, rest} = decode_morse(morsemsg, tree)
    List.to_string([char | decode(rest, tree)])
  end

  def decode_morse([], _) do {46, []} end
  def decode_morse([first|rest], {:node, val, l, r}) do
      case first do
        45 -> decode_morse(rest, l) # "-"
        46 -> decode_morse(rest, r) # "."
        32 -> {val, rest}
      end
  end

  # The map structure in elixir has a O(1) access time due to being
  # implemented using a hash table.
  # This construction of the map can be implemented better.
  def hash_map(morse) do
    hash_map(morse, [])
  end
  def hash_map({:node, :na, left, right}, path) do
    Map.merge(hash_map(left, path ++ [1]), hash_map(right, path ++ [0]))
  end
  def hash_map({:node, char, nil, nil}, path) do
    %{char => path}
  end
  def hash_map({:node, char, left, right}, path) do
    Map.merge(Map.merge(%{char => path}, hash_map(right, path ++ [0])), hash_map(left, path ++ [1]))
  end
  def hash_map(nil, _) do %{} end

  def morse() do
    {:node, :na,
      {:node, 116,
        {:node, 109,
          {:node, 111,
            {:node, :na, {:node, 48, nil, nil}, {:node, 57, nil, nil}},
            {:node, :na, nil, {:node, 56, nil, {:node, 58, nil, nil}}}},
          {:node, 103,
            {:node, 113, nil, nil},
            {:node, 122,
              {:node, :na, {:node, 44, nil, nil}, nil},
              {:node, 55, nil, nil}}}},
        {:node, 110,
          {:node, 107, {:node, 121, nil, nil}, {:node, 99, nil, nil}},
          {:node, 100,
            {:node, 120, nil, nil},
            {:node, 98, nil, {:node, 54, {:node, 45, nil, nil}, nil}}}}},
      {:node, 101,
        {:node, 97,
          {:node, 119,
            {:node, 106,
              {:node, 49, {:node, 47, nil, nil}, {:node, 61, nil, nil}},
              nil},
            {:node, 112,
              {:node, :na, {:node, 37, nil, nil}, {:node, 64, nil, nil}},
              nil}},
          {:node, 114,
            {:node, :na, nil, {:node, :na, {:node, 46, nil, nil}, nil}},
            {:node, 108, nil, nil}}},
        {:node, 105,
          {:node, 117,
            {:node, 32,
              {:node, 50, nil, nil},
              {:node, :na, nil, {:node, 63, nil, nil}}},
            {:node, 102, nil, nil}},
          {:node, 115,
            {:node, 118, {:node, 51, nil, nil}, nil},
            {:node, 104, {:node, 52, nil, nil}, {:node, 53, nil, nil}}}}}}
  end

  def hash(morse) do
    hash(morse, [])
  end
  def hash({:node, :na, left, right}, path) do
    hash(left, path ++ [1]) ++ hash(right, path ++ [0])
  end
  def hash({:node, char, nil, nil}, path) do
    [{char, path}]
  end
  def hash({:node, char, left, nil}, path) do
    [{char, path}] ++ hash(left, path ++ [1])
  end
  def hash({:node, char, nil, right}, path) do
    [{char, path}] ++ hash(right, path ++ [0])
  end
  def hash({:node, char, left, right}, path) do
    [{char, path}] ++ hash(right, path ++ [0]) ++ hash(left, path ++ [1])
  end
  def hash(nil, _) do [] end

  def test_hash_morse() do
    morse = morse()
    hash = hash_map_morse(morse)
    decode_hash(mor(), hash)
    #Map.new(hash, fn {morse, char} -> {morse, List.to_string([char])} end)
  end

  def hash_map_morse(morse) do
    hash_map_morse(morse, [])
  end
  def hash_map_morse({:node, :na, left, right}, path) do
    Map.merge(hash_map_morse(left, path ++ '-'), hash_map_morse(right, path ++ '.'))
  end
  def hash_map_morse({:node, char, nil, nil}, path) do
    %{path => char}
  end
  def hash_map_morse({:node, char, left, nil}, path) do
    Map.merge(%{path => char}, hash_map_morse(left, path ++ '-'))
  end
  def hash_map_morse({:node, char, nil, right}, path) do
    Map.merge(%{path => char}, hash_map_morse(right, path ++ '.'))
  end
  def hash_map_morse({:node, char, left, right}, path) do
    Map.merge(Map.merge(%{path => char}, hash_map_morse(right, path ++ '.')), hash_map_morse(left, path ++ '-'))
  end
  def hash_map_morse(nil, _) do %{} end


  def decode_hash(morse, hash) do
    morse = String.split(morse, "\s")
    decode_hash(morse, hash, [])
  end
  def decode_hash([], _, list) do list end
  def decode_hash([char|text], hash, list) do
    decode_hash(text, hash, list ++ hash[char])
  end
end
