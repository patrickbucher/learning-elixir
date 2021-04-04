# Learn Functional Programming with Elixir

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

## Using Pattern Matching to Control the Program Flow

Pattern matching is not the same as assignment:

    > x = 1
    1
    > 1 = x
    1
    > 2 = x
    ** (MatchError) no match of right hand side value: 1

Unlike Erlang, Elixir allows rebinding variables:

    > x = 1
    1
    > x = 2
    2

The pin operator `^` makes sure that a match is performed against the value,
which avoids re-binding:

    > x = 3
    > x = 4
    > ^x = 4
    4
    > ^x = 5
    ** (MatchError) no match of right hand side value: 5

Pattern matching can be used to unpack parts of values from expressions
(_destructuring_):

    > "Patrick " <> lastname = "Patrick Bucher"
    "Patrick Bucher"
    > lastname
    "Bucher"

Tuples can be used to signify success and error of an operation:

    > {:ok, value} = {:ok, 13}
    {:ok, 13}
    > {:ok, value} = {:error, :not_found}
    ** (MatchError) no match of right hand side value: {:error, :not_found}

In general, functions should return `{:ok, result}` in case of success,
and `{:error, :error_type}` in case of failure.

The underscore `_` matches any value, which is then discarded:

    > {_, _, third, _} = {13, 17, 22, 18}
    {13, 17, 22, 18}
    > third
    22

List elements can be separated using the `|` operator:

    > [head | tail] = [1, 2, 3]
    [1, 2, 3]
    > head
    1
    > tail
    [2, 3]

It is possible to match multiple elements on the left side:

    > [a, b | tail] = [1, 2, 3]
    [1, 2, 3]
    > a
    1
    > b
    2
    > tail
    [3]

Map literals can be written in two ways:

    > user = %{email: "joe.doe@mail.com", password: "topsecret"}
    %{email: "joe.doe@mail.com", password: "topsecret"}

    > user = %{:email => "joe.doe@mail.com", :password => "topsecret"}
    %{email: "joe.doe@mail.com", password: "topsecret"}

The first way is more compact, the second way allows for any value in
the key (not just atoms).

Map values can be extracted by matching keys:

    > %{password: password} = user
    %{email: "joe.doe@mail.com", password: "topsecret"}
    > password
    "topsecret"

Either syntax works:

    > %{:password => password} = user
    %{email: "joe.doe@mail.com", password: "topsecret"}
    > password
    "topsecret"

Maps can not only be matched for certain keys, but also for values:

    > %{email: "joe.doe@mail.com", password: password} = user
    %{email: "joe.doe@mail.com", password: "topsecret"}
    > password
    "topsecret"

Matching and extraction can also be combined:

    > %{email: email = "joe.doe@mail.com"} = user
    %{email: "joe.doe@mail.com", password: "topsecret"}
    > email
    "joe.doe@mail.com"

Pinning accomplishes the same in two steps, which is useful if the value
to be matched has to be computed beforehand:

    > email = "joe.doe@mail.com"
    > %{email: ^email} = user
    %{email: "joe.doe@mail.com", password: "topsecret"}
    > email
    "joe.doe@mail.com"

Keyword lists contain two-element tuples that may contain duplicate
keys:

    > animals = [dog: "Bello", cat: "Pussy", dog: "Doggo", cat: "Whiskers"]
    [dog: "Bello", cat: "Pussy", dog: "Doggo", cat: "Whiskers"]

They are also used in imports; functions with the same name but
different arities can be imported:

    > import String, only: [pad_leading: 2, pad_leading: 3]

Structs are maps with a fixed set of keys to represent things such as
calendar dates. They can be matched like maps:

    > birthday = ~D[1987-06-24]
    > %{year: year} = birthday
    > year
    1987

The match can be refined using the type name:

    > %Date{year: year} = birthday
    > year
    1987
    > %Date{year: year} = %{year: 2005}
    ** (MatchError) no match of right hand side value: %{year: 2005}


_Sigils_ like `~D` are syntactic sugar to build objects from text representations.
Other examples are the word list sigil `~w` or the reguar expression
sigil `~r`:

    > ~w(Dilbert Alice Wally)
    ["Dilbert", "Alice", "Wally"]

    > pattern = ~r/^clean:$/
    ~r/^clean:$/

Multiple functions with the same signature can be used for pattern
matching:

    defmodule NumberCompare do
      def greater(number, other_number) do
        check(number >= other_number, number, other_number)
      end

      defp check(true, number, _), do: number
      defp check(false, _, other_number), do: other_number
    end

The `check` function has multiple _clauses_, defined with `defp`, so
that they are not visible from outside of the module. Clauses belonging
to the same function must stand in a sequence that must not be
interrupted by other function's clauses.

Default values for function parameters can be defined using the `\\`
operator:

    defmodule Checkout do
      def total_cost(price, quantity \\ 10), do: price * quantity
    end

Internally, two functions are created: one expecting the `quantity`
parameter, and one having it set already. Only one default value can be
used for a function definition.

The above function can be captured and used as follows:

    > total_default = &Checkout.total_cost/1
    > total = &Checkout.total_cost/2
    > total_default.(2)
    20
    > total_default.(2, 10)
    20
    value per function.

Guard clauses can be used to control which function clause is executed:

    defmodule NumberCompare do
      def greater(number, other_number) when number >= other_number, do: number
      def greater(_, other_number), do: other_number
    end

The first clause is protected with a guard expression. If it doesn't
match, the first clause is taken.

Pattern matching and guards can be used in anonymous functions, too:

    number_compare = fn
      number, other_number when number >= other_number -> number
      _, other_number -> other_number
    end

    number_compare.(1, 8)
    number_compare.(7, 3)

Only authorized functions that are pure can be used in guard
expressions, e.g. those from the `Integer` module (`even_or_odd.ex`):

    defmodule EvenOrOdd do
      require Integer

      def check(number) when Integer.is_even(number), do: "even"
      def check(number) when Integer.is_odd(number), do: "odd"
    end

    > c("even_or_odd.ex")
    [EvenOrOdd]
    > EvenOrOdd.check(3)
    "odd"
    > EvenOrOdd.check(2)
    "even"

Here, `require` has to be used, so that the `Integer` functions can be
used at compile-time. Definitions added using `require` are lexically
scoped, and, thus, only available in the respective scope.

Guards can be re-used by defining them using the `defguard` keyword:

    defmodule Checkout do
      defguard is_rate(value) when is_float(value) and value >= 0 and value <= 1
      defguard is_cents(value) when is_integer(value) and value >= 0

      def total_cost(price, tax_rate) when is_cents(price) and is_rate(tax_rate) do
        price + tax_cost(price, tax_rate)
      end

      def tax_cost(price, tax_rate) when is_cents(price) and is_rate(tax_rate) do
        price * tax_rate
      end
    end

    > c("checkout.ex")
    [Checkout]
    > Checkout.tax_cost(40, 0.1)
    4.0
    > Checkout.total_cost(40, 0.1)
    44.0

Multiple pattern-matching clauses can be checked using a `case`
expression:

    user_input = IO.gets "What's your IQ? "
    case Integer.parse(user_input) do
      :error -> IO.puts "Malformed IQ: #{user_input}"
      {iq, _} -> IO.puts "Your IQ is #{iq}"
    end

The `case` expression returns a value:

    user_input = IO.gets "What's your IQ? "
    output = case Integer.parse(user_input) do
      :error -> "Malformed IQ: #{user_input}"
      {iq, _} -> "Your IQ is #{iq}"
    end
    IO.puts output

Different variables and/or values can be checked usign `cond`:

    {weight_kg, _} = Integer.parse(IO.gets("Weight [kg]: "))
    {height_cm, _} = Integer.parse(IO.gets("Height [cm]: "))

    height_m = height_cm / 100
    height_square = height_m * height_m
    bmi = weight_kg / height_square

    result = cond do
      bmi < 20 -> "BMI #{bmi} is underweight"
      bmi <= 25 -> "BMI #{bmi} is good"
      bmi > 25 -> "BMI #{bmi} is overweight"
    end

    IO.puts result

`if`/`else` and `unless/else` can be used for simple (binary) checks:

    a = 13
    b = 3

    bigger = if a > b do
      a
    else
      b
    end

    smaller = unless a > b do
      a
    else
      b
    end

    IO.puts "bigger: #{bigger}"
    IO.puts "smaller: #{smaller}"

They are actually implemented as macros and can be used as follows, too:

    > bigger = if(a > b, do: a, else: b)
    > smaller = unless(a > b, do: a, else: b)

## Diving into Recursion

The _boundary clause_ (trivial case) must always be listed before the
case that applies repeatedly (general case):

    defmodule Sum do
      def up_to(0), do: 0
      def up_to(n), do: n + up_to(n - 1)
    end

Lists are usually processed element by element by splitting the list's
`head` from its `tail`:

    defmodule Math do
      def sum([]), do: 0
      def sum([head | tail]), do: head + sum(tail)
    end

List can also be built by prepending elements using the `[head | tail]`
syntax:

    defmodule EnchanterShop do
      def test_data do
        [
          %{title: "Longsword", price: 50, magic: false},
          %{title: "Healing Potion", price: 60, magic: true},
          %{title: "Rope", price: 10, magic: false},
          %{title: "Dragon's Spear", price: 100, magic: true},
        ]
      end
      
      @enchanter_name "Edwin"
      
      def enchant_for_sale([]), do: []
      def enchant_for_sale([item = %{magic: true} | incoming_items]) do
        [item | enchant_for_sale(incoming_items)]
      end
      def enchant_for_sale([item | incoming_items]) do
        new_item = %{
          title: "#{@enchanter_name}'s #{item.title}",
          price:  item.price * 3,
          magic: true
        }
        [new_item | enchant_for_sale(incoming_items)]
      end
    end

The second `enchant_for_sale` clause only matches on items having set
the `magic` key to `true`. The third `enchant_for_sale` clause will
therefore, implicitly, only process the items having set `magic` to
`false`.

The items of a map can also be accessed using their keys, either using
square brackets (missing keys return `nil`) or using the dot notation
(missing keys raise a `KeyError`)::

    > [head | tail] = EnchanterShop.test_data

    > head[:magic]
    false
    > head[:price]
    50
    > head[:title]
    "Longsword"
    > head[:size]
    nil

    > head.magic
    false
    > head.price
    50
    > head.title
    "Longsword"
    > head.size
    ** (KeyError) key :size not found in: %{magic: false, price: 50, title: "Longsword"}

A factorial function can be implemented using the _decrease and conquer_
technique, where the problem left to be solved is decreased on every
step:

    defmodule Factorial do
      def of(0), do: 1
      def of(n) when n > 0, do: n * of(n - 1)
    end

A sort function, such as merge sort, can be implemented using the
_divide and conquer_ technique, where the initial problem is divided
into easier to solve sub-problems:

    defmodule Sort do

      def ascending([]), do: []
      def ascending([a]), do: [a]
      def ascending(list) do
        half_size = div(Enum.count(list), 2)
        {list_a, list_b} = Enum.split(list, half_size)
        merge(ascending(list_a), ascending(list_b))
      end

      defp merge([], list_b), do: list_b
      defp merge(list_a, []), do: list_a
      defp merge([head_a | tail_a], list_b = [head_b | _]) when head_a <= head_b do
        [head_a | merge(tail_a, list_b)]
      end
      defp merge(list_a = [head_a | _], [head_b | tail_b]) when head_a > head_b do
        [head_b | merge(list_a, tail_b)]
      end

    end

_Tail-recursive_ only have a single function call as their last step.
Such functions can be optimized by the compiler. They often use
additional _accumulator_ parameters:

    defmodule TRFactorial do
      def of(n), do: factorial_of(n, 1)
      defp factorial_of(0, acc), do: acc
      defp factorial_of(n, acc) when n > 0, do: factorial_of(n - 1, n * acc)
    end

The problem is reduced as `n` shrinks, and the accumulator storing the
intermediate result, grows.

Recursive structures, such as linked web pages or the file system, are
best processed using recursive functions.

    defmodule Navigator do

      @max_depth 3

      def navigate(dir) do
        expanded_dir = Path.expand(dir)
        go_through([expanded_dir], 0)
      end

      defp go_through([], _current_depth), do: nil
      defp go_through(_dirs, current_depth) when current_depth > @max_depth, do: nil
      defp go_through([content | rest], current_depth) do
        print_and_navigate(content, File.dir?(content), current_depth)
        go_through(rest, current_depth)
      end

      defp print_and_navigate(_dir, false, _current_depth), do: nil
      defp print_and_navigate(dir, true, current_depth) do
        IO.puts dir
        children_dirs = File.ls!(dir)
        go_through(expand_dirs(children_dirs, dir), current_depth + 1)
      end

      defp expand_dirs([], _relative_to), do: []
      defp expand_dirs([dir | dirs], relative_to) do
        expanded_dir = Path.expand(dir, relative_to)
        [expanded_dir | expand_dirs(dirs, relative_to)]
      end

    end

The `depth` of the recursion is restricted, adding a _boundary_ to the
recursive problem.

## Using Higher-Order Functions

Higher-Order functions accept other functions as parameters, and/or
return functions.

The `each` function applies the given function (second parameter) to
each item in the list (first parameter):

    defmodule MyList do
      def each([], _function), do: nil
      def each([head | tail], function) do
        function.(head)
        each(tail, function)
      end
    end

It can be used as follows to output all the list items:

    > c("my_list.ex")
    > MyList.each(["Alice", "Bob", "Mallory"], fn item -> IO.puts item end)
    Alice
    Bob
    Mallory
    nil

The `map` function transforms a given list by applying the given
function to each element:

    def map([], _function), do: []
    def map([head | tail], function) do
      [function.(head) | map(tail, function)]
    end

    > MyList.map(["Alice", "Bob", "Mallory"], fn item -> String.length(item) end)
    [5, 3, 7]

    > MyList.map(["Alice", "Bob", "Mallory"], &String.length/1)
    [5, 3, 7]

    > discount = fn item -> update_in(item.price, &(&1 * 0.9)) end
    > items = [%{name: "Beer", price: 2.50}, %{name: "Water", price: 1.20}]
    > MyList.map(items, discount)
    [%{name: "Beer", price: 2.25}, %{name: "Water", price: 1.08}]

The `reduce` function computes an aggregate value over a given list. The
accumulator is used both for storing intermediate results, and to
initialize a neutral element:

    def reduce([], acc, _function), do: acc
    def reduce([head | tail], acc, function) do
      reduce(tail, function.(head, acc), function)
    end

    > MyList.reduce([1, 2, 3, 4], 0, &(&1 + &2))
    10
    > MyList.reduce([1, 2, 3, 4], 1, &(&1 * &2))
    24
    > MyList.reduce([1, 2, 3, 4], 0, &+/2)
    10
    > MyList.reduce([1, 2, 3, 4], 1, &*/2)
    24

The `filter` function applies a predicate function on every item, and
produces a list only consisting of the items for with the predicate
holds true:

    def filter([], _function), do: []
    def filter([head | tail], function) do
      if function.(head) do
        [head | filter(tail, function)]
      else
        filter(tail, function)
      end
    end

    > MyList.filter([1, 2, 3, 4, 5, 6], &(rem(&1, 2) == 0))
    [2, 4, 6]

These functions, and many more, are all available in the `Enum` module:

- `Enum.each/2`
- `Enum.map/2`
- `Enum.reduce/2` (without neutral element)
- `Enum.reduce/3` (with neutral element)
- `Enum.filter/2`
- `Enum.count/1`
- `Enum.sort/2`
- `Enum.sum/1`
- `Enum.uniq/1`
- `Enum.member?/2`
- `Enum.join/2`

`Enum`'s functions work with any type respecting the `Enumerable`
protocol (lists, maps, tuples, etc.).

Some functions require multiple functions as parameters. The `group_by`
function needs one function to extract a grouping criterion, and one
function to extract an identifier from the items:

    employees = [
      %{department: :engineering, name: "Dilbert"},
      %{department: :management, name: "Pointy Haired Boss"},
      %{department: :engineering, name: "Wally"},
      %{department: :hr, name: "Catbert"},
      %{department: :marketing, name: "Ted"},
      %{department: :management, name: "Egghead"},
      %{department: :engineering, name: "Alice"},
    ]

    departments = Enum.group_by(employees, &(&1.department), &(&1.name))
    IO.inspect departments

Output:

  $ elixir departments.exs
    %{
      engineering: ["Dilbert", "Wally", "Alice"],
      hr: ["Catbert"],
      management: ["Pointy Haired Boss", "Egghead"],
      marketing: ["Ted"]
    }

List comprehensions are created using the `for` form and one or mor
generator expressions:

    > for i <- [1, 2, 3, 4, 5], do: i * i
    [1, 4, 9, 16, 25]

Multiple generator expressions can be used to build the _carthesian
product_ (i.e. all combinations) of the listed items:

    > for a <- ["1", "2", "3"], b <- ["a", "b", "c"], do: a <> b
    ["1a", "1b", "1c", "2a", "2b", "2c", "3a", "3b", "3c"]

Conditions can be used to restrict the items going into the result list:

    > for i <- [1, 2, 3, 4, 5, 6], rem(i, 2) == 0, do: i
    [2, 4, 6]

Functions can be composed using the pipe operator `|>`:

    > "test" |> String.first |> String.upcase
    "T"

    > "to kill a mockingbird"
      |> String.split
      |> Enum.map(&String.capitalize/1)
      |> Enum.join(" ")
    "To Kill A Mockingbird"

Instead of currying, functions can be partially applied using closures. The
`String.at` function is partially applied with `alphabet`, and can later be u
sed by calling `partial`.

    defmodule WordBuilder do
      def build(alphabet, positions) do
        partial = fn at -> String.at(alphabet, at) end
        letters = Enum.map(positions, partial)
        Enum.join(letters)
      end
    end

The same can be expressed using function-capturing syntax:

    defmodule WordBuilder do
      def build(alphabet, positions) do
        letters = Enum.map(positions, &(String.at(alphabet, &1)))
        Enum.join(letters)
      end
    end

Infinite collections of data are possible using lazy evaluation and the `Stream`
module. Simple streams can be expressed using the range literal:

    > numbers = 1..10
    > Enum.each(1..10, &IO.puts/1)
    1
    2
    ...
    10
    :ok

The factorial can be computed as follows using ranges:

    defmodule Factorial do
      def of(0), do: 1
      def of(n) when n > 0 do
        1..10_000_000
          |> Enum.take(n)
          |> Enum.reduce(&(&1 * &2))
      end
    end

Ranges are only evaluated as needed. An infinite stream of numbers can be
created as follows:

    > integers = Stream.iterate(1, fn prev -> prev + 1 end)
    > Enum.take(integers, 3)
    [1, 2, 3]

Which can be used to re-factor the factorial implementation from above:

    defmodule Factorial do
      def of(0), do: 1
      def of(n) when n > 0 do
        Stream.iterate(1, fn prev -> prev + 1 end)
          |> Enum.take(n)
          |> Enum.reduce(&(&1 * &2))
      end
    end

It's possible to cycle endlessly through an enumeration (`halloween.ex`):

    defmodule Halloween do
      def give_candy(kids) do
        ~w(chocolate jelly mint)
          |> Stream.cycle
          |> Enum.zip(kids)
      end
    end

    > c("halloween.ex")
    Halloween.give_candy(~w(Alice Bob Carol Dan Enia Frank))
    [
      {"chocolate", "Alice"},
      {"jelly", "Bob"},
      {"mint", "Carol"},
      {"chocolate", "Dan"},
      {"jelly", "Enia"},
      {"mint", "Frank"}
    ]

There are two ways a list of items can be processed by a pipeline of functions:

1. Eager: Every function processes the whole list and sends the result to the
   next function.
2. Lazy: A function only processes a finite amount of items and sends the
   partial result to the next function.

While the first approach makes sense for very small tasks, the second approach
produces results earlier for further processing.

`ScrewsFactory` (`screws_factory.ex`) simulates the process of producing screws
from metal pieces, here with the first (eager) approach:

    defmodule ScrewsFactory do

      def run(pieces) do
        pieces
        |> Enum.map(&add_thread/1)
        |> Enum.map(&add_head/1)
        |> Enum.each(&output/1)
      end

      defp add_thread(piece) do
        Process.sleep(50)
        piece <> "--"
      end

      defp add_head(piece) do
        Process.sleep(100)
        "o" <> piece
      end

      defp output(screw) do
        IO.inspect(screw)
      end

    end

    > c("screws_factory.ex")
    > metal_pieces = Enum.take(Stream.cycle(["-"]), 10)
    ["-", "-", "-", "-", "-", "-", "-", "-", "-", "-"]
    > ScrewsFactory.run(metal_pieces)
    "o---"
    "o---"
    "o---"
    "o---"
    "o---"
    "o---"
    "o---"
    "o---"
    "o---"
    "o---"
    :ok

First, nothing happens, then, all of a sudden, the ten screws appear.

The `run` function can be changed as follows in order to use lazy evaluation:

    defmodule ScrewsFactory do

      def run(pieces) do
        pieces
        |> Stream.map(&add_thread/1)
        |> Stream.map(&add_head/1)
        |> Enum.each(&output/1)
      end

    # ...

By chunking the list of pieces, each function can process a partial list instead
of only a single element:

    defmodule ScrewsFactory do

      def run(pieces) do
        pieces
        |> Stream.chunk_every(50)
        |> Stream.flat_map(&add_thread/1)
        |> Stream.chunk_every(100)
        |> Stream.flat_map(&add_head/1)
        |> Enum.each(&output/1)
      end

      defp add_thread(pieces) do
        Process.sleep(50)
        Enum.map(pieces, &(&1 <> "--"))
      end

      defp add_head(pieces) do
        Process.sleep(100)
        Enum.map(pieces, &("o" <> &1))
      end

      defp output(screw) do
        IO.inspect(screw)
      end

    end

`Enum.chunk` is the eager version of the same concept:

    > Enum.chunk(1..6, 2)
    [[1, 2], [3, 4], [5, 6]]

`Enum.flat_map` does the opposite:

    > chunks = Enum.chunk(1..6, 2)
    > Enum.flat_map(chunks, &(&1))
    [1, 2, 3, 4, 5, 6]

## Designing Your Elixir Applications

Create a new application using `mix`:

    $ mix new dungeon_crawl
    $ cd dungeon_crawl

Run the tests:

    $ mix test

New mix tasks can be created under `lib/mix/tasks`, e.g. `start.ex`:

    defmodule Mix.Tasks.Start do
      use Mix.Task

      def run(_), do: IO.puts "Hello, World!"
    end

The task can be run as follows:

    $ mix start
    Compiling 2 files (.ex)
    Generated dungeon_crawl app
    Hello, World!

The task function `run` must be part of the `Mix.Tasks` module and accept a
single argument.

New structs can be defined using `defstruct`
(`dungeon_crawl/lib/dungeon_crawl/character.ex`):

    defmodule DungeonCrawl.Character do
      defstruct name: nil,
        description: nil,
        hit_points: 0,
        max_hit_points: 0,
        attack_description: nil,
        damage_range: nil
    end

Load all modules automatically using `mix` (in the project's root folder):

    $ iex -S mix

A struct can be created as follows:

    > warrior = %DungeonCrawl.Character{name: "Warrior"}
    %DungeonCrawl.Character{
      attack_description: nil,
      damage_range: nil,
      description: nil,
      hit_points: 0,
      max_hit_points: 0,
      name: "Warrior"
    }
    > warrior.name
    "Warrior"
