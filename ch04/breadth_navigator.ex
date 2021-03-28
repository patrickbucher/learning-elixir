defmodule BreadthNavigator do

  @max_breadth 3

  def navigate(dir) do
    expanded_dir = Path.expand(dir)
    go_through([expanded_dir])
  end

  defp go_through([]), do: nil
  defp go_through([content | rest]) do
    print_and_navigate(content, File.dir?(content))
    go_through(rest)
  end

  defp print_and_navigate(file, false), do: IO.puts "#{file}"
  defp print_and_navigate(dir, true) do
    IO.puts dir
    children_dirs = File.ls!(dir)
    go_through(expand_dirs(children_dirs, dir, 0, []))
  end

  defp expand_dirs([], _relative_to, _breadth, acc), do: acc
  defp expand_dirs([dir | dirs], relative_to, breadth, acc) when breadth < @max_breadth do
    expanded_dir = Path.expand(dir, relative_to)
    expand_dirs(dirs, relative_to, breadth + 1, [expanded_dir | acc])
  end
  defp expand_dirs(_dirs, _relative_to, _breadth, acc), do: acc

end
