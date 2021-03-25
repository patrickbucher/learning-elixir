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
