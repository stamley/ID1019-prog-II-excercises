defmodule Huffman do
  def sample do
    'the quick brown fox jumps over the lazy dog
    this is a sample text that we will use when we build
    up a table we will only handle lower case letters and
    no punctuation symbols the frequency will of course not
    represent english but it is probably not that far off'
  end
  def text() do
    'this is something that we should encode'
  end

  def test do
    file = read("kallocain.txt")
    sample = file
    tree = tree(sample)
    table = encode_table(tree)
    #sequence = encode(sample, table)

    #decode(sequence, table)
    timer("Kallocain (0.3mb):", sample, table)

    file = read("lorem.txt")
    sample = file
    tree = tree(sample)
    table = encode_table(tree)

    timer("Lorem Ipsum (2mb):", sample, table)

    file = read("randomchars.txt")
    sample = file
    tree = tree(sample)
    table = encode_table(tree)

    timer("Random chars (4mb):", sample, table)

    file = read("random.txt")
    sample = file
    tree = tree(sample)
    table = encode_table(tree)

    timer("Random ascii (4mb):", sample, table)
  end
  def timer(file, sample, table) do
    {time1, sequence} = :timer.tc(fn () -> encode(sample, table) end)
    {time2, _} = :timer.tc(fn () -> decode(sequence, table) end)
    IO.puts("#{file}\nEncoding: #{time1/1000000}\nDecoding: #{time2/1000000}")
  end

  def to_char({left, right}) do {to_char(left), to_char(right)} end
  def to_char(leaf) do List.to_string([leaf]) end

  # This results in a tree of characters. It is possible to
  # pair them with their frequency, but this is not necessary
  # since we only want a translation from a code to a character.

  def tree(sample) do
    freq = freq(sample)
    treeify(List.keysort(freq, 1))
  end
  # For the last element examined, the tree structure is finished
  def treeify([{tree, _}]) do tree end
  def treeify([{c1, n}, {c2, m}|rest]) do
    treeify(add({{c1, c2}, n+m}, rest))
  end

  # add
  # Based on the frequency of the node or the leaf, the elements
  # will place itself correctly, and continue "merging".
  # This is to create the tree structure that will be ordered by frequency
  # of characters. Making the highly frequent characters be decoded with fewer bits.

  def add({c, n}, []) do [{c, n}] end
  # c1 can be pair aswell
  # If the frequency for the chosen character is lower than
  # the next one, it is in its correct place.
  def add({c1, n}, [{c2, m}|rest]) when n < m do
    [{c1, n}, {c2, m}|rest]
  end
  # Otherwise, it needs to continue down the list, to place itself
  def add({c1, n}, [{c2, m}|rest]) do
    [{c2, m}|add({c1, n}, rest)]
  end

  # List of frequencies of letters
  def freq(sample) do freq(sample, []) end
  def freq([], freq) do freq end
  def freq([char | rest], freq) do
    freq(rest, refresh(char, freq))
  end

  def refresh(char, []) do [{char, 1}] end
  def refresh(char, [{char, n}|freq]) do
    [{char, n+1}|freq]
  end
  def refresh(char, [nomatch|freq]) do
    [nomatch|refresh(char, freq)]
  end

  # Creates list of mappings for characters to "paths" down the
  # huffman tree. This will correspond to their translation.
  def encode_table(tree) do
    encode_table(tree, [])
  end
  def encode_table({left, right}, path) do
    encode_table(left, path ++ [0]) ++ encode_table(right, path ++ [1])
  end
  # "List.to_string([leaf])"
  def encode_table(leaf, path) do [{leaf, path}] end

  #def decode_table(_tree) do # To implement...end

  # Gives list of bits translating text to encoded text
  def encode([], _) do [] end
  def encode([char|text], table) do
    encode_char(char, table)++encode(text, table)
  end

  # Traverses table to find encoding for specific character
  def encode_char(char, [{char, path}|_]) do path end
  def encode_char(char, [_|table]) do encode_char(char, table) end

  # Start decoding the sequence with just one bit,
  # this will be increased as long as there is no translation
  # for this particular bit.
  # For the rest of the list this will be continued.
  # For example the first character are bits 101, Then the next
  # character starts searching with one bit, let's say 0, and that
  # exists, then this will be the character chosen.
  def decode([], _) do [] end
  def decode(sequence, table) do
    {char, rest} = decode_char(sequence, 1, table)
    [char | decode(rest, table)]
  end

  # Take the first n bits from the sequence, if there is a match
  # the character can be returned aswell as the rest of the sequence.
  # Otherwise, one has to examine n+1 bits instead to see if there is
  # a translation that matches with a larger amount of bits.
  def decode_char(sequence, n, table) do
    {code, rest} = Enum.split(sequence, n)
    case List.keyfind(table, code, 1) do
      {char, _} -> {char, rest}
      nil -> decode_char(sequence, n+1, table)
    end
  end

  # Reads file
  def read(file) do
    {:ok, file} = File.open(file, [:read, :utf8])
    binary = IO.read(file, :all)
    File.close(file)
    case :unicode.characters_to_list(binary, :utf8) do
      {:incomplete, list, _} -> list
      list -> list
    end
  end
end
