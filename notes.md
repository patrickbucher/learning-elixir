# Elixir

Run Elixir's interactive shell:

    $ iex

Create a _"Hello, World!"_ program in the interactive shell:

    iex> IO.puts "Hello, World!"
    Hello, World!
    :ok

There are two extensions for Elixir files:

1. `.ex` for files to be compiled
2. `.exs` for script files to be executed directly

Create a _"Hello, World!"_ program in a file called `hello_world.exs`:

    IO.puts "Hello, World!"

Run the program using Elixir:

    $ elixir hello_world.exs
    Hello, World!

## Thinking Functionally

Elixir uses immutable data structures. The original `list` object is never
modified, but new list objects are returned.

    > list = [1, 2, 3, 4]
    [1, 2, 3, 4]
    > List.delete_at(list, -1)
    [1, 2, 3]
    > list ++ [1]
    [1, 2, 3, 1]
    > list
    [1, 2, 3, 4]

`delete_at` is not a method of the list itself, but a function of the
`List` module, which can be applied to lists, and that returns new lists
instead of modifying an underlying list.

A pure function only depends on its parameters:

    > twice = fn (n) -> n * 2 end
    > twice.(3)
    6

Instead of maintaining internal state with classes, modules provide
functions that operate on data without manipulating it, but returning
the modified versions of that data (`set.exs`):

    defmodule MySet do
      defstruct items: []
      def push(set = %{items: items}, item) do
        if Enum.member?(items, item) do
          set
        else
          %{set | items: items ++ [item]}
        end
      end
    end

This module can be used as follows:

    $ iex set.exs
    > set = %MySet{}
    > set = MySet.push(set, "apple")
    > new_set = %MySet{}
    > new_set = MySet.push(new_set, "pie")
    > IO.inspect MySet.push(set, "apple")
    %MySet{items: ["apple"]}
    > IO.inspect MySet.push(new_set, "apple")
    %MySet{items: ["pie", "apple"]}

Functions can be used as arguments. Here, the `upcase` function of the
`String` module is applied to a list of strings:

    > Enum.map(["dogs", "cats", "mice"], &String.upcase/1)
    ["DOGS", "CATS", "MICE"]

The result of a function call can be used as the parameter to a subsequent
function call using the pipe operator `|>`. Instead of using nested function
calls:

    > String.split(String.downcase(String.trim("  THIS IS A TEST  ")))
    ["this", "is", "a", "test"]

The pipe operator can be used to chain the function calls together:

    > "  THIS IS A TEST  " |> String.trim |> String.downcase |> String.split
    ["this", "is", "a", "test"]

Instead of explicitly stating the control flow, this recursive function
only defines the steps to transform the data (`stringlist.exs`):

    defmodule StringList do
      def upcase([]), do: []
      def upcase([first | rest]), do: [String.upcase(first) | upcase(rest)]
    end

Which can be used as follows:

    $ iex stringlist.exs
    > StringList.upcase(["foo", "bar", "baz", "bum"])
    ["FOO", "BAR", "BAZ", "BUM"]

Higher-order functions simplify commonly used operations such as
processing lists of items:

    > list = ["foo", "bar", "baz", "bum"]
    > Enum.map(list, &String.upcase/1)
    ["FOO", "BAR", "BAZ", "BUM"]

## Working with Variables and Functions

Basic data types:

- `string`: `"Hello, World"`, `"foobar"`, `"/home/patrick"`
- `integer`: `42`, `123`, `10_000`
- `float`: `3.14`, `9.95`, `-10.01`
- `boolean`: `true`, `false`
- `atom`: `:ok`, `:error`, `:exit` (identifiers)
- `tuple`: `{:ok, "Hello"}`, `{1, 2, 3}` (collections of known sizes)
- `list`: `[1, 2, 3]`, `["foo", "bar", "baz"]` (collections of unknown sizes)
- `map`: (lookup values by key)
    - `%{id: 123, name: "John"}`
    - `%{12 => "Alice"}`
- `nil`: `nil` (absence of a value)

Operators:

- `+`, `-`, `/`, `*`: basic arithmetic
- `==`, `!=`, `<`, `<=`, `>`, `>=`: comparison
- `++`: list concatenation
    - `[1, 2, 3] ++ [4, 5]` -> `[1, 2, 3, 4, 5]`
- `<>`: binary concatenation (strings and binaries)
    - `"what" <> "ever"` -> `"whatever"`

There are two versions of logical operators:

- `and`, `or`, `not` working on `boolean` expressions
    - the left side of the operator must be a `boolean` expression
- `&&`, `||`, `!` working on "truthy"/"falsy" expressions
    - "falsy": `false` and `nil`
    - "truthy": everything that is not "falsy"

Examples:

    > true and false
    false
    > true or false
    true
    > true and not false
    true

    > nil && 1
    false
    > true && "Hello"
    true
    > false || 4
    true
    > 1 && !5
    false

Anonymous functions have no global name, but can be bound to variables
for reference:

    > say_hi_to = fn name -> "Hello, #{name}!" end
    > say_hi_to.("Alice")
    "Hello, Alice!"
    > say_hi_to.("Bob")
    "Hello, Bob!"

The `say_hi_to` function uses string interpolation syntax (`#{e}`). The
expression `e` is coecred into a string.

Anonymous functions (or "lambdas") can take multiple parameters:

    > calc_circumference = fn height, width -> 2 * height + 2 * width end
    > calc_circumference.(3, 4)
    14

They can also take other functions as arguments:

    > apply = fn a, b, op -> op.(a, b) end
    > average = fn a, b -> (a + b) / 2 end
    > apply.(3, 7, average)
    5.0

Here, the `average` function is passed as the `op` parameter to the
`apply` function.

A closure remembers the variables of its lexical scope:

    > message = "Hello, World!"
    > say_hi = fn -> Process.sleep(1000); IO.puts(message) end
    > message = "Something else"
    > spawn(say_hi)
    > message = "Whatever"
    Hello, World!

Even though the `message` binding was overwritten, the `say_hi` function
still remembers the value `"Hello, World!"`.

Modules are named using _aliases_ (`String`) or _atoms_ (`:"Elixir.String"`).
Aliases transform into atoms during compile time:

    > String == :"Elixir.String"
    true

Aliases start with a capital letter and may only contain ASCII characters.
Because of the `.`, the atom `Elixir.String` above is quoted.

Named functions of a module can be accessed using the dot operator.
Parentheses are optional.

    > String.upcase "without parentheses"
    "WITHOUT PARENTHESES"
    > String.upcase("with parentheses")
    "WITH PARENTHESES"

The following basic modules contain many commonly used named functions:

- `String`: text
    - `String.capitalize("hi")` -> `"HI"`
    - `String.downcase("HI")` -> `"hi"`
- `Integer`: integers
    - `Integer.parse("123")` -> `{123, ""}`
    - `Integer.to_string(123)` -> `"123"`
    - `Integer.digits(1987)` -> `[1, 9, 8, 7]`
- `Float`: floating point numbers
    - `Float.ceil(3.7)` -> `4.0`
    - `Float.floor(3.7)` -> `3.0`
    - `Float.round(3.4999)` -> `3.0`
- `IO`: input/output
    - `IO.puts("Hello!")` -> outputs `"Hello!"`
    - `IO.gets("Name? ")` -> outputs `"Name? "`, returns user input
    - `IO.inspect({:ok, 123})` outputs `{:ok, 123}`
- `Kernel`: common functions, can be used without qualifier
    - `div(3, 2)` -> `1`
    - `rem(3, 2)` -> `1`
    - `is_number("foo")` -> `false`

Modules should be defined in their own file (`checkout.ex`):

  defmodule Checkout do
    def total_cost(price, tax_rate) do
      price * (tax_rate + 1)
    end
  end

The module name starts with an uppercase character, the file name is in
all lowercase. Module names use `CamelCase`, function and variable names
use `snake_case`.

The function automatically returns the evaluation of its last
expression, no `return` statement is required.

A module can be compiles as follows in `iex`:

    > c("checkout.ex")
    [Checkout]

A list of the compiled modules (`[Checkout]`) is returned. The module
then can be used as any other module:

    > Checkout.total_cost(100, 0.2)
    120.0

The function can also be defined on a single line within the module:

    def total_cost(price, tax_rate), do: price * (tax_rate + 1)

Notice the comma before and the colon after the `do` keyword, as well as
the lack of an `end` keyword.

Name collisions can be avoided by prefixing the module's name with the
application's name:

    defmodule Ecommerce.Checkout do
    ...

The file `checkout.ex` then needs to be placed in a directory called
`ecommerce`.

Then the fully qualified name has to be used to invoce the module's function:

    > Ecommerce.Checkout.total_cost(100, 0.2)

A module can be imported so that its functions can be invoked without
fully qualify their names:

    > import Checkout
    > total_cost(100, 0.2)

It's also possible to only import a subset of a module's functions into
the current namespace (`task_list.ex`):

    defmodule TaskList do

      import File, only: [write: 3, read: 1]

      @file_name "task_list.md"

      def add(task_name) do
        task = "[ ] #{task_name}\n"
        write(@file_name, task, [:append])
      end

      def show_list do
        read(@file_name)
      end

    end

The _arity_ of the functions being imported needs to be defined
explicitly (`write: 3`, `read: 1`); it states the number of parameters
the function expects.

`@file_name` is a module attribute, here being used as a constant. The
module can be used as follows:

    $ iex
    > c("task_list.ex")
    [TaskList]
    > TaskList.add("wash the dishes")
    :ok
    > TaskList.add("walk the dog")
    :ok
    > TaskList.show_list()
    {:ok, "[ ] wash the dishes\n[ ] walk the dog\n"}

The arity needs to be stated when referring to named functions using the
capturing operator `&`:

    > upcase = &String.upcase/1
    > upcase.("hi")
    "HI"

The `total_cost` function from above can be re-defined as follows:

    > total_cost = &(&1 * &2)
    > total_cost.(10, 2)

The function's parameters can be referred to using `&1`, `&2`, etc. in
their order used at the invocation.

The parentheses are optional:

    > total_cost = & &1 * &2 

The capture syntax is shorter to type but might be less clear to read
due to the lack of parameter names.
